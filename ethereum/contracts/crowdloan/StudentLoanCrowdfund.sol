
pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../core/StudentLoanTypes.sol";

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

    //This works like a mintable token, supply starts at zero. If and when we make it an actual token we can replace this.
    mapping (address => uint) debtTokens;
    uint debtTokensSupply;

    enum LoanStatus {
        NOT_STARTED,
        PARTIALLY_FUNDED,
        FULLY_FUNDED,
        STARTED
    }

    LoanStatus loanStatus;
    StudentLoanParams loanParams;

    uint totalRepaid;

    IERC20 debtToken;
    IERC20 loanToken;

    event AddFunding(address indexed lender, uint indexed amount);
    event RevokeFunding(address indexed lender, uint indexed amount);
    event WithdrawPayment(address indexed lender, uint indexed amount);

    modifier onlyDebtHolder() {
        require(debtToken[msg.sender] > 0, NO_DEBT_TOKENS);
        _;
    }

    constructor(
        address _debtTokenAddr,
        address _loanTokenAddr,
        StudentLoanParams _params
    ) {
        debtToken = IERC20(_debtTokenAddr);
        loanToken = IERC20(_loanTokenAddr);
        loanParams = _params;
    }

    function addFunding(uint amount) public {
        //Calculate how many debt tokens to give them
        uint debtTokensToAdd = loanParams.principalAmount;
        _addDebtTokens(msg.sender, debtTokensToAdd);
    }
    function revokeFunding() public onlyDebtHolder() {
        //This should only be allowed after a lockup time
        //Return funds to lender
        //Remove all debt tokens
    }
    function withdrawRepayment() public onlyDebtHolder() {
        // User should be able to withdraw
    }

    function getRepayment() public view {

    }

    function _addDebtTokens(address recipient, uint amount) internal {
        //Invariant: Ensure the debt tokens are still a proper amount in total
    }

    function _burnDebtTokens(address recipient, uint amount) internal {

    }
}
