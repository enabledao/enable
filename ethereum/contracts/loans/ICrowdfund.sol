pragma solidity ^0.5.2;

interface ICrowdfund {
    function addFunding(uint amount) external returns (uint tokenId);
    function revokeFunding(uint debtTokenId) external;
    function withdrawRepayment(uint debtTokenId, uint amount) external;
    function getAvailableWithdrawal(uint debtTokenId) external view returns (uint);
}