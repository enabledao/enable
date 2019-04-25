pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./LoanRequest.sol";

contract LoanRequestFactory is Ownable {

    event LoanRequestCreated(address contractAddress, address indexed requester, address ownershipToken, address indexed loanCurrency, uint principal, uint interestRate, uint repayments, uint[] repaymentSchedule);

    constructor() Ownable() public {}

    function createLoanRequest(address ownershipToken, address loanCurrency, uint principal, uint interestRate, uint repayments, uint[] memory repaymentSchedule) public {
        LoanRequest loanRequest = new LoanRequest(ownershipToken, loanCurrency, principal, interestRate, repayments, repaymentSchedule);
        emit LoanRequestCreated(address(loanRequest), msg.sender, ownershipToken, loanCurrency, principal, interestRate, repayments, repaymentSchedule);
    }
}
