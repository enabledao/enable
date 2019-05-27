pragma solidity ^0.5.2;

// @notice Registry for Enable core contract addresses. Modelled after Dharma ContractRegistry.
interface IEnableContractRegistry {

    function permissionsLib() external returns(address);
    function studentLoanCrowdfundFactory() external returns(address);
}