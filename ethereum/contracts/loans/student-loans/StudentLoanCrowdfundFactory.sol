pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "../../core/EnableContractRegistry.sol";

import "./StudentLoanCrowdfund.sol";
import "./StudentLoanLibrary.sol";
import "../DebtToken.sol";

contract StudentLoanCrowdfundFactory is Ownable {
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;
    using StudentLoanLibrary for StudentLoanLibrary.AmortizationUnitType;

    EnableContractRegistry enableRegistry;

    event StudentLoanCrowdfundCreated(
        address indexed crowdfundAddress,
        address indexed debtTokenAddress,
        address paramStorageAddress,
        uint paramIndex
    );

    constructor(address _enableRegistry) public {
        enableRegistry = EnableContractRegistry(_enableRegistry);
    }

    // @notice Create a new crowdfund contract, passing in all required parameters
    function createStudentLoanCrowdfund(
        uint principalTokenIndex,
        uint principalAmount,
        uint interestRate,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount
    ) public returns (address) {
        
        // Store parameters in Storage
        uint paramIndex = enableRegistry.studentLoanTermsStorage().add(
            principalTokenIndex,
            principalAmount,
            interestRate,
            amortizationUnitType,
            termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount,
            standardPaymentAmount
        );

        // Create Crowdfund contract
        StudentLoanCrowdfund crowdfund = new StudentLoanCrowdfund(
            address(enableRegistry),
            paramIndex
        );
        
        // Create DebtToken contract
        address debtTokenAddress = enableRegistry.debtTokenFactory().createDebtToken("Social Bond", "SBOND");
        DebtToken token = DebtToken(debtTokenAddress);
        
        // Link the two
        crowdfund.setDebtToken(debtTokenAddress);
        token.addMinter(address(crowdfund));
        token.renounceMinter();

        emit StudentLoanCrowdfundCreated(
            address(crowdfund),
            debtTokenAddress,
            address(enableRegistry.studentLoanTermsStorage()),
            paramIndex
        );
        return address(crowdfund);
    }

}
