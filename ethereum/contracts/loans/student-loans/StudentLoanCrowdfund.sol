
pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "../ICrowdfund.sol";
import "./StudentLoanTermsStorage.sol";
import "./StudentLoanLibrary.sol";

contract StudentLoanCrowdfund is ICrowdfund {
    using SafeMath for uint;
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;

    // Constants
    uint constant public BLANK_TOKEN_PARTS = 10**18;
    uint constant public MINIMUM_PRICE = 10**18;
    uint constant public MINIMUM_PAYMENT = 10**18;
    uint constant public MAXIMUM_PAYMENT = 10**22;

    // Error Codes
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

    IERC721Full debtToken;

    event AddFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event RevokeFunding(address indexed sender, uint indexed amount, uint indexed tokenId);
    event WithdrawPayment(address indexed sender, uint indexed amount, uint indexed tokenId);

    // @notice Only users who hold debt tokens can call
    modifier onlyDebtHolder(uint tokenId) {
        // @TODO: add logic once token is completed
        _;
    }

    constructor(
        address _termsStorage,
        address _debtToken,
        uint _paramsIndex
    ) public {
        termsStorage = StudentLoanTermsStorage(_termsStorage);
        termStorageIndex = _paramsIndex;

        //Get principal and mint max token size based on this
    }

    function addFunding(uint amount) public returns (uint tokenId) {
        //Calculate how many debt tokens to give them based on loan data
    }
    function revokeFunding(uint tokenId) public onlyDebtHolder(tokenId) {
        //This should only be allowed after a lockup time?
        //Return funds to lender
        //Remove all debt tokens
    }
    function withdrawRepayment(uint tokenId, uint amount) public onlyDebtHolder(tokenId) {
        // User should be able to withdraw their accumlated repayments at any time
    }

    function getAvailableWithdrawal(uint tokenId) public view returns (uint) {

    }
}
