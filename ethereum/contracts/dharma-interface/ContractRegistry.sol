pragma solidity ^0.5.2;

interface ContractRegistry {
    function collateralizer() external returns(address);
    function debtKernel() external returns(address);
    function debtRegistry() external returns(address);
    function debtToken() external returns(address);
    function repaymentRouter() external returns(address);
    function tokenRegistry() external returns(address);
    function tokenTransferProxy() external returns(address);
}
