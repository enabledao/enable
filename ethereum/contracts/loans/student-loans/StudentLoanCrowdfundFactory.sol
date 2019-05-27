pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./StudentLoanCrowdfund.sol";
import "./StudentLoanTermsStorage.sol";
import "./StudentLoanTermsContract.sol";

contract StudentLoanCrowdfundFactory is Ownable {

    StudentLoanTermsStorage termsStorage;
    StudentLoanTermsContract termsContract;

    event StudentLoanCrowdfundCreated(
        address indexed crowdfundAddress,
        address paramStorageAddress,
        uint paramIndex,
        uint principalTokenIndex,
        uint principalAmount,
        uint interestRate,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount
    );

    constructor(address _termsStorage, address _termsContract) public {
        termsStorage = StudentLoanTermsStorage(_termsStorage);
        termsContract = StudentLoanTermsContract(_termsContract);
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
    ) public {

        uint paramIndex = termsStorage.add(
            principalTokenIndex,
            principalAmount,
            interestRate,
            amortizationUnitType,
            termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount,
            standardPaymentAmount
        );

        StudentLoanCrowdfund crowdfund = new StudentLoanCrowdfund(
            termsStorage,
            paramIndex
        );

        emit StudentLoanCrowdfundCreated(
            address(crowdfund),
            termsStorage,
            paramIndex,
            principalTokenIndex,
            principalAmount,
            interestRate,
            amortizationUnitType,
            termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount,
            standardPaymentAmount
        );
    }

}
