pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./StudentLoanLibrary.sol";

import "../../core/EnableContractRegistry.sol";

// @notice Stores instance information for each Student Loan, as the information is too large for the Dharma bytes32 format. 
/* 
    If a loan is funded, it is approved to call this and add data.
    This happens if it has a given method to call, and has enough of the right ERC-20 tokens at it's address.
    Need to think about how this could be scammed by imitating a loan contract...
    Unless they can overwrite previous loan data, I don't see a problem...
    But someone could spam params additions by transferring ERC-20's around a bunch of new contracts that imitate loan requests
    OTOH they're paying for it so who carse?
    But the events are fired anyways
    We need to rethink this approach.

    We could also store the params in the loan request and have the index -> params mapping in a factory.
    This means loans would have to be created via the factory to have a chance of being valid.
*/
contract StudentLoanTermsStorage is Ownable {
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;
    using StudentLoanLibrary for StudentLoanLibrary.AmortizationUnitType;

    EnableContractRegistry enableRegistry;

    mapping (uint => StudentLoanLibrary.StoredParams) paramRegistry;
    uint paramCount;

    event LoanParamsAdded(
        uint index,
        uint principalTokenIndex,
        uint principalAmount,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount,
        uint interestRate
    );

    constructor(address _enableRegistryAddr) public {
        enableRegistry = EnableContractRegistry(_enableRegistryAddr);
    }

    //TODO: only authorized contracts, aka funded Crowdloans during submission, should be able to call this. 
    function add(
        uint principalTokenIndex,
        uint principalAmount,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount,
        uint interestRate
    ) public returns (uint) {

        uint index = paramCount;

        StudentLoanLibrary.StoredParams memory params = StudentLoanLibrary.StoredParams({
            principalTokenIndex: principalTokenIndex,
            principalAmount: principalAmount,
            amortizationUnitType: StudentLoanLibrary.AmortizationUnitType(amortizationUnitType),
            termLengthInAmortizationUnits: termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits: gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount: gracePeriodPaymentAmount,
            standardPaymentAmount: standardPaymentAmount,
            interestRate: interestRate
        });

        paramRegistry[index] = params;
        paramCount++;

        emit LoanParamsAdded(
            index,
            principalTokenIndex,
            principalAmount,
            amortizationUnitType,
            termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount,
            standardPaymentAmount,
            interestRate
        );

        return index;
    }

    // @notice Retrieve all the stored parameters at a given index
    function get(uint index) public view returns(
        uint principalTokenIndex,
        uint principalAmount,
        StudentLoanLibrary.AmortizationUnitType amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount,
        uint interestRate
    ) {
        
        StudentLoanLibrary.StoredParams memory params = paramRegistry[index];

        return (
            params.principalTokenIndex,
            params.principalAmount,
            params.amortizationUnitType,
            params.termLengthInAmortizationUnits,
            params.gracePeriodInAmortizationUnits,
            params.gracePeriodPaymentAmount,
            params.standardPaymentAmount,
            params.interestRate
        );
    }

}