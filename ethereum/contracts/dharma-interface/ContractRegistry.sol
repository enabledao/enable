pragma solidity ^0.5.2;

import "./Collateralizer.sol";
import "./DebtKernel.sol";
import "./DebtRegistry.sol";
import "./DebtToken.sol";
import "./RepaymentRouter.sol";
import "./TokenRegistry.sol";
import "./TokenTransferProxy.sol";


contract ContractRegistry {
    Collateralizer public collateralizer;
    DebtKernel public debtKernel;
    DebtRegistry public  debtRegistry;
    DebtToken public debtToken;
    RepaymentRouter public repaymentRouter;
    TokenRegistry public tokenRegistry;
    TokenTransferProxy public tokenTransferProxy;
}
