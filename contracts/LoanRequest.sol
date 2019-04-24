pragma solidity ^0.5.2;

import "./crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
import "./crowdsale/validation/CappedCrowdsale.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

//TODO: Try extending crowdsale 
/*
    Differences from crowdsale: Rather than paying with ether, you pay with the token of choice. 
    You must approve before calling.

    The fallback function just refunds - we don't accept ether here. (Need to evaluate re-entrancy)

    So we may have to override huge parts of it, but we'll see
*/

contract LoanRequest is RefundablePostDeliveryCrowdsale, CappedCrowdsale {
    address public requester;
    IERC20 ownershipToken;
    IERC20 loanCurrency;

    uint public constant ownershipTokenRate = 1;

    struct Loan {
        uint principal;
        uint interestRate;
        uint repayments;
        uint startTime;
        uint[] repaymentSchedule;
    }

    Loan loan;

    event LoanRequestCreated(address indexed requester, address ownershipToken, address loanCurrency, uint principal, uint interestRate, uint repayments, uint[] repaymentSchedule);

    event FundsReleased(uint released);
    event FundsWithdrawn(uint withdrawn);
        
    constructor(
        address _ownershipToken,
        address _loanCurrency,
        uint _principal,
        uint _interestRate,
        uint _repayments,
        uint[] memory _repaymentSchedule
    ) RefundableCrowdsale(_principal) TimedCrowdsale(now, now + 1000000) CappedCrowdsale(_principal) Crowdsale(ownershipTokenRate, address(this), IERC20(_ownershipToken)) public {
        require(_repaymentSchedule.length == _repayments);

        loan.principal = _principal;
        loan.interestRate = _interestRate;
        loan.repayments = _repayments;
        loan.repaymentSchedule = _repaymentSchedule;

        requester = msg.sender;
        ownershipToken = IERC20(_ownershipToken);
        loanCurrency = IERC20(_loanCurrency);

        emit LoanRequestCreated(requester, address(ownershipToken), address(loanCurrency), loan.principal, loan.interestRate, loan.repayments, loan.repaymentSchedule);
    }

    /* Overridden functions - We buy shares with a given loan token, not with ether */  

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer funds with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    function () external payable {
        buyTokens(msg.sender);
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     * @param beneficiary Recipient of the token purchase
     * @param amount Value of tokens sent
     */
    function buyTokens(address beneficiary, uint amount) public nonReentrant {
        // uint256 weiAmount = msg.value;
        loanCurrency.safeTransferFrom(msg.sender, wallet(), amount);

        _preValidatePurchase(beneficiary, amount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(amount);

        // update state
        _weiRaised = _weiRaised.add(amount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, amount, tokens);

        _updatePurchasingState(beneficiary, amount);

        _forwardFunds();
        _postValidatePurchase(beneficiary, amount);
    }  
}
