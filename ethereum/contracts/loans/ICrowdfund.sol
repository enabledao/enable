pragma solidity ^0.5.2;

contract ICrowdfund {
    function addFunding(uint amount) public returns (uint tokenId);
    function revokeFunding(uint debtTokenId) public;
    function withdrawRepayment(uint debtTokenId, uint amount) public;
    function getAvailableWithdrawal(uint debtTokenId) public view returns (uint);
}