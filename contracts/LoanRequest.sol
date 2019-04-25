pragma solidity ^0.5.2;

import "./crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
import "./crowdsale/validation/CappedCrowdsale.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "./TokenTransfer.sol";

//TODO: Try extending crowdsale
/*
    Differences from crowdsale: Rather than paying with ether, you pay with the token of choice.
    You must approve before calling.

    The fallback function just refunds - we don't accept ether here. (Need to evaluate re-entrancy)

    So we may have to override huge parts of it, but we'll see
*/

contract LoanRequest is RefundablePostDeliveryCrowdsale, CappedCrowdsale, TokenTransfer {
    address public requester;
    IERC20 ownershipToken;
    IERC20 loanCurrency;

    uint public constant ownershipTokenRate = 1;
    uint private nextRepayment;

    struct Loan {
        uint principal;
        uint interestRate;
        uint repayments;
        uint startTime;
        uint repaymentTenor;
        uint[] repaymentSchedule;
    }

    Loan loan;

    event FundsReleased(uint released);
    event FundsWithdrawn(uint withdrawn);
    event LoanRepayed(uint repayment, uint cycles);

    constructor(
        address _requester,
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

        requester = _requester;
        ownershipToken = IERC20(_ownershipToken);
        loanCurrency = IERC20(_loanCurrency);
    }

    function _getRepaymentScheduleSum () internal view returns (uint) {
        uint repaymentSum;
        for( uint s=0; s < loan.repayments; s++) {
          repaymentSum = repaymentSum + loan.repaymentSchedule[s];
        }
        return repaymentSum;
    }

    function _getRepaymentTimestamp (uint _repayment) internal view returns (uint) {
        return loan.startTime + ((_repayment+1) * loan.repaymentTenor);
    }

    function _getCyclesPast () internal view returns (uint) {
        uint nextRepaymentTimestamp = _getRepaymentTimestamp(nextRepayment);
        uint timeSinceRepayment = now - nextRepaymentTimestamp;
        uint cyclesPast = timeSinceRepayment / loan.repaymentTenor;
        cyclesPast = (nextRepayment + cyclesPast) > loan.repayments ? loan.repayments - nextRepayment : cyclesPast;
    }

    function _calcRepaymentAmount (uint _repaymentStartIndex,uint _repaymentCycles) internal view returns (uint) {
        uint totalDue;
        uint scheduleSum = _getRepaymentScheduleSum();
        // TODO Account for interest rate
        for (uint r = _repaymentStartIndex; r < (_repaymentStartIndex + _repaymentCycles); r++) {
          totalDue = totalDue + (loan.principal * ( loan.repaymentSchedule[r] / scheduleSum ));
        }
        return totalDue;
    }

    function _getEffectiveRepaymentAmount (uint _amount) internal view returns (uint, uint) {
        uint totalCyclesPast = _getCyclesPast();
        uint totalDue = totalRepaymentDue();
        uint exactCyclesPast;
        uint exactAmountDue;

        if (_amount >= totalDue || _amount == 0) {
          return (totalDue, totalCyclesPast);
        } else {
          for (uint c=0; (c<totalCyclesPast && exactAmountDue < _amount); c++) {
            uint cycleRepayment = _calcRepaymentAmount(nextRepayment, c+1);
            if (_amount >= cycleRepayment) {
              exactCyclesPast = c+1;
              exactAmountDue = cycleRepayment;
            }
          }
          return (exactAmountDue, exactCyclesPast);
        }
    }

    function totalRepaymentDue () public view returns (uint) { //Doubles as repayment due check
        uint cyclesPast = _getCyclesPast();
        if (cyclesPast == 0) {
          return 0;
        } else {
            // TODO Account for missed repayment penalties if cyclesPast > 1
          return _calcRepaymentAmount(nextRepayment, cyclesPast);
        }
    }

    function repayLoan (uint amount) public returns (bool) {
        (uint totalDue, uint paidCycles) = _getEffectiveRepaymentAmount(amount);
        require(_receiveTokens(address(loanCurrency), msg.sender, totalDue));
        nextRepayment = nextRepayment + paidCycles;
        // TODO Kill or freeze Tokens, once loan totally repaid
        emit LoanRepayed(totalDue, paidCycles);
    }

    function repayLoan () public returns (bool) {
        return repayLoan (0);
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
