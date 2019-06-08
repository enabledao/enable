
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
        REPAYMENT_COMPLETE
    }

    // Storage Variables
    LoanStatus loanStatus;
    uint termStorageIndex;

    EnableContractRegistry enableRegistry;

    uint totalRepaid;
    mapping (address => uint) withdrawn;

    DebtToken debtToken;

    event AddFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event RevokeFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event WithdrawPayment(address indexed sender, uint indexed amount, uint indexed tokenId);

    event DebtTokenSet(address debtToken);
    event LoanStatusChanged(uint newStatus);

    // @notice Only users who hold debt tokens can call
    modifier onlyDebtHolder(uint tokenId) {
        // @TODO: add logic once token is completed
        require(msg.sender == debtToken.ownerOf(tokenId), 'Not owner of Debt token');
        _;
    }

    // @notice Only users who hold debt tokens can call
    modifier isState(LoanStatus tokenId) {
        // @TODO: add logic once token is completed
        require(msg.sender == debtToken.ownerOf(tokenId), 'Not owner of Debt token');
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
      ) = getLoanDetails();
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
      ) = getLoanDetails();
      require (debtToken.totalDebt().add(amount) <= params.principalAmount);

      if (debtToken.totalDebt() > 0 && debtToken.totalDebt() <  params.principalAmount) {
        loanStatus = loanStatus.PARTIALLY_FUNDED;
      } else if ()

      if (loanStatus == debtToken.totalDebt() >=  params.principalAmount)
      setLoanStatus(LoanStatus.PARTIALLY_FUNDED);
    }

    constructor(address _enableRegistry, uint _paramsIndex) public {
        enableRegistry = EnableContractRegistry(_enableRegistry);
        termStorageIndex = _paramsIndex;
    }

    // @notice setthe present state of the Loan;
    function setLoanStatus(LoanStatus _loanStatus) internal {
        if (loanStatus != _loanStatus) {
            loanStatus = _loanStatus;
            emit LoanStatusChanged(loanStatus);
        }
    }

    // @notice Only the creator can set the debt token;
    function setDebtToken(address _debtTokenAddr) public onlyOwner {
        debtToken = DebtToken(_debtTokenAddr);
        emit DebtTokenSet(_debtTokenAddr);
    }

    function addFunding(uint amount) public belowMaxSupply(amount) trackLoanStatus returns (uint tokenId) {
        //Calculate how many debt tokens to give them based on loan data
        // Allocate exact amount
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
        ) = getLoanDetails();
        address principalTokenAddress = enableRegistry.tokenRegistry().getTokenAddressByIndex(params.principalTokenIndex);
        TransferTokenLib.validatedTransferFrom(IERC20(principalTokenAddress), msg.sender, address(this), amount);
        tokenId = debtToken.create(msg.sender, amount);
    }

    function revokeFunding(uint tokenId) public onlyDebtHolder(tokenId) {
        //This should only be allowed after a lockup time?
        //Return funds to lender
        //Remove all debt tokens
    }
    function withdrawRepayment(uint tokenId, uint amount) public onlyDebtHolder(tokenId) {
        // User should be able to withdraw their accumlated repayments at any time
    }

    function getLoanDetails () internal view returns (
      uint, uint, StudentLoanLibrary.AmortizationUnitType, uint, uint, uint, uint, uint
    ) {
      return enableRegistry.studentLoanTermsStorage().get(termStorageIndex);
    }

    function getAvailableWithdrawal(uint tokenId) public view returns (uint) {

    }

    function agreementId () public view returns (uint) {
      // return
    }
}
