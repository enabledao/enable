
pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "./StudentLoanTermsStorage.sol";

contract StudentLoanCrowdfund is StudentLoanTypes {
    using SafeMath for uint;

    uint constant public BLANK_TOKEN_PARTS = 10**18;
    uint constant public MINIMUM_PRICE = 10**18;
    uint constant public MINIMUM_PAYMENT = 10**18;
    uint constant public MAXIMUM_PAYMENT = 10**22;

    string private constant INSUFFICIENT_PAYMENT = "0";
    string private constant EXCEEDED_PAYMENT = "1";
    string private constant TOKENS_NOT_AVAILABLE = "2";
    string private constant INVALID_AMOUNT = "3";
    string private constant REFERRER_NA = "4";
    string private constant NO_DEBT_TOKENS = "5";

    mapping (address => bool) lenders;
    uint lendersCount;

    enum LoanStatus {
        NOT_STARTED,
        PARTIALLY_FUNDED,
        FULLY_FUNDED,
        LOAN_STARTED,
        REPAYMENT_STARTED,
        REPAYMENT_COMPLETE
    }

    StudentLoanTermsStorage termsStorage;
    uint termStorageIndex;
    
    LoanStatus loanStatus;

    uint totalRepaid;
    mapping (address => uint) withdrawn;

    IERC20 debtToken;
    IERC20 loanToken;

    event AddFunding(address indexed lender, uint indexed amount);
    event RevokeFunding(address indexed lender, uint indexed amount);
    event WithdrawPayment(address indexed lender, uint indexed amount);

    // @notice Only users who hold debt tokens can call
    modifier onlyDebtHolder() {
        // @TODO: add logic once token is completed
        _;
    }

    constructor(
        address _termsStorage,
        uint _paramsIndex
    ) public {
        loanToken = //Get loan token from params
        termsStorage = StudentLoanTermsStorage(termsStorage);
        termStorageIndex = _paramsIndex;

        //Get principal and mint max token size based on this
    }

    function addFunding(uint amount) public {
        //Calculate how many debt tokens to give them
        uint debtTokensToAdd = loanParams.principalAmount;
        _addDebtTokens(msg.sender, debtTokensToAdd);
    }
    function revokeFunding() public onlyDebtHolder() {
        //This should only be allowed after a lockup time?
        //Return funds to lender
        //Remove all debt tokens
    }
    function withdrawRepayment() public onlyDebtHolder() {
        // User should be able to withdraw their accumlated repayments at any time
    }

    function getAvailableWithdrawal() public view returns (uint) {

    }
}
