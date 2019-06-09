
pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

import "../../core/EnableContractRegistry.sol";
import "../../core/TransferTokenLib.sol";
import "./StudentLoanLibrary.sol";

import "../ICrowdfund.sol";
import "../DebtToken.sol";

contract StudentLoanCrowdfund is ICrowdfund, Ownable {
    using SafeMath for uint;
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;

    // Constants
    uint constant public BLANK_TOKEN_PARTS = 10**18;
    uint constant public MINIMUM_PRICE = 10**18;
    uint constant public MINIMUM_PAYMENT = 10**18;
    uint constant public MAXIMUM_PAYMENT = 10**22;

    // Error Codes
    uint private constant INSUFFICIENT_PAYMENT = 0;
    uint private constant EXCEEDED_PAYMENT = 1;
    uint private constant TOKENS_NOT_AVAILABLE = 2;
    uint private constant INVALID_AMOUNT = 3;
    uint private constant REFERRER_NA = 4;
    uint private constant NO_DEBT_TOKENS = 5;

    enum LoanStatus {
        NOT_STARTED,
        PARTIALLY_FUNDED,
        FULLY_FUNDED,
        LOAN_STARTED,
        REPAYMENT_STARTED,
        REPAYMENT_COMPLETE,
        CANCELLED
    }

    // Storage Variables
    LoanStatus loanStatus = LoanStatus.CANCELLED;
    uint termStorageIndex;
    uint crowdfundLength;
    uint crowdfundStart;

    EnableContractRegistry enableRegistry;

    uint totalRepaid; //Total repayment from the borrower
    mapping (uint => uint) withdrawn; //Amount withdrawn on each tokenId

    DebtToken debtToken;

    event AddFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event RevokeFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event WithdrawPayment(address indexed sender, uint indexed amount, uint indexed tokenId);

    event DebtTokenSet(address debtToken);
    event LoanStatusChanged(LoanStatus newStatus);

    // @notice Only users who hold debt tokens can call
    modifier onlyDebtHolder(uint tokenId) {
        // @TODO: add logic once token is completed
        require(msg.sender == debtToken.ownerOf(tokenId), 'Not owner of Debt token');
        _;
    }

    // @notice Action only allowed during crowdfund period
    modifier duringCrowdfund {
        require(now >= crowdfundStart && now < (crowdfundStart + crowdfundLength), 'Crowdfund eith not started or ended');
        _;
    }

    // @notice Only payments that do not exceed the pricipal Amount allowed
    modifier belowMaxSupply (uint amount) {
      StudentLoanLibrary.StoredParams memory params;
      (
        params.principalTokenIndex,
        params.principalAmount,
        params.amortizationUnitType,
        params.termLengthInAmortizationUnits,
        params.gracePeriodInAmortizationUnits,
        params.gracePeriodPaymentAmount,
        params.standardPaymentAmount,
        params.interestRate
      ) = _getLoanDetails();
      require (debtToken.totalDebt().add(amount) <= params.principalAmount);
      _;
    }

    modifier trackLoanStatus () {
      _;

      StudentLoanLibrary.StoredParams memory params;
      (
        params.principalTokenIndex,
        params.principalAmount,
        params.amortizationUnitType,
        params.termLengthInAmortizationUnits,
        params.gracePeriodInAmortizationUnits,
        params.gracePeriodPaymentAmount,
        params.standardPaymentAmount,
        params.interestRate
      ) = _getLoanDetails();

      if (debtToken.totalDebt() > 0 && debtToken.totalDebt() <  params.principalAmount) {
        _setLoanStatus(LoanStatus.PARTIALLY_FUNDED);
      } else if (debtToken.totalDebt() >=  params.principalAmount && totalRepaid == 0) {
        _setLoanStatus(LoanStatus.FULLY_FUNDED);
      } else if (totalRepaid > 0 && totalRepaid < getTotalRepaymentDue()) {
        _setLoanStatus(LoanStatus.REPAYMENT_STARTED);
      } else if (totalRepaid >= getTotalRepaymentDue()) {
        _setLoanStatus(LoanStatus.REPAYMENT_COMPLETE);
      }
    }

    constructor(address _enableRegistry, uint _paramsIndex, uint _crowdfundLength) public {
        enableRegistry = EnableContractRegistry(_enableRegistry);
        termStorageIndex = _paramsIndex;
        crowdfundLength = _crowdfundLength;
    }

    function _isState (LoanStatus _loanStatus) internal view returns (bool) {
        return loanStatus == _loanStatus;
    }

    function _getLoanDetails () internal view returns (
      uint, uint, StudentLoanLibrary.TimeUnits, uint, uint, uint, uint, uint
    ) {
      return enableRegistry.studentLoanTermsStorage().get(termStorageIndex);
    }

    // @notice setthe present state of the Loan;
    function _setLoanStatus(LoanStatus _loanStatus) internal {
        if (loanStatus != _loanStatus) {
            loanStatus = _loanStatus;
            emit LoanStatusChanged(loanStatus);
        }
    }

    // @notice Only the creator can set the debt token;
    function beginCrowdfund() public onlyOwner {
        require (crowdfundStart == 0, 'Crowdfund previously started');
        _setLoanStatus(LoanStatus.NOT_STARTED);
        crowdfundStart = now;
    }

    // @notice Only the creator can set the debt token;
    function setDebtToken(address _debtTokenAddr) public onlyOwner {
        debtToken = DebtToken(_debtTokenAddr);
        emit DebtTokenSet(_debtTokenAddr);
    }

    function addFunding(uint amount) public belowMaxSupply(amount) duringCrowdfund trackLoanStatus returns (uint tokenId) {
        //Calculate how many debt tokens to give them based on loan data
        // Allocate exact amount

        require(_isState(LoanStatus.NOT_STARTED) || _isState(LoanStatus.PARTIALLY_FUNDED), 'Action not possible at the moment');

        StudentLoanLibrary.StoredParams memory params;
        (
          params.principalTokenIndex,
          params.principalAmount,
          params.amortizationUnitType,
          params.termLengthInAmortizationUnits,
          params.gracePeriodInAmortizationUnits,
          params.gracePeriodPaymentAmount,
          params.standardPaymentAmount,
          params.interestRate
        ) = _getLoanDetails();
        address principalTokenAddress = enableRegistry.tokenRegistry().getTokenAddressByIndex(params.principalTokenIndex);
        TransferTokenLib.validatedTransferFrom(IERC20(principalTokenAddress), msg.sender, address(this), amount);
        tokenId = debtToken.create(msg.sender, amount);
    }

    function revokeFunding(uint tokenId) public onlyDebtHolder(tokenId) trackLoanStatus {
        //This should only be allowed after a lockup time?
        //Return funds to lender
        //Remove all debt tokens
        require(uint8(loanStatus) < uint8(LoanStatus.LOAN_STARTED), 'Action not possible at the moment');

    }
    function withdrawRepayment(uint tokenId, uint amount) public onlyDebtHolder(tokenId) {
        // User should be able to withdraw their accumlated repayments at any time
    }

    function getTotalRepaymentDue () public view returns (uint) {

    }

    function getAvailableWithdrawal(uint tokenId) public view returns (uint) {

    }

    function agreementId () public view returns (uint) {
      // return
    }
}
