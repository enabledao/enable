pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./StudentLoanTypes.sol";

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
    address loanFactory;
    address termsContract;
    
    struct StudentLoanParams {
        uint principalTokenIndex;
        uint principalAmount;
        AmortizationUnitType amortizationUnitType;
        uint termLengthInAmortizationUnits;
        uint gracePeriodInAmortizationUnits;
        uint gracePeriodPaymentAmount;
        uint standardPaymentAmount;

        // Given that Solidity does not support floating points, we encode
        // interest rates as percentages scaled up by a factor of 10,000
        // As such, interest rates can, at a maximum, have 4 decimal places
        // of precision.
        uint interestRate;
    }
    
    struct StudentLoanDerivedParams {
        uint principalTokenAddress;
        uint termStartUnixTimestamp;
        uint termEndUnixTimestamp;
        uint gracePeriodEndUnixTimestamp;
    }

    enum AmortizationUnitType { HOURS, DAYS, WEEKS, MONTHS, YEARS }
    uint public constant NUM_AMORTIZATION_UNIT_TYPES = 5;

    uint public constant HOUR_LENGTH_IN_SECONDS = 60 * 60;
    uint public constant DAY_LENGTH_IN_SECONDS = HOUR_LENGTH_IN_SECONDS * 24;
    uint public constant WEEK_LENGTH_IN_SECONDS = DAY_LENGTH_IN_SECONDS * 7;
    uint public constant MONTH_LENGTH_IN_SECONDS = DAY_LENGTH_IN_SECONDS * 30;
    uint public constant YEAR_LENGTH_IN_SECONDS = DAY_LENGTH_IN_SECONDS * 365;

     // To convert an encoded interest rate into its equivalent in percents,
    // divide it by INTEREST_RATE_SCALING_FACTOR_PERCENT -- e.g.
    //     10,000 => 1% interest rate
    uint public constant INTEREST_RATE_SCALING_FACTOR_PERCENT = 10 ** 4;
    // To convert an encoded interest rate into its equivalent multiplier
    // (for purposes of calculating total interest), divide it by INTEREST_RATE_SCALING_FACTOR_PERCENT -- e.g.
    //     10,000 => 0.01 interest multiplier
    uint public constant INTEREST_RATE_SCALING_FACTOR_MULTIPLIER = INTEREST_RATE_SCALING_FACTOR_PERCENT * 100;

    mapping (uint => StudentLoanParams) paramRegistry;
     uint paramCount;

    event LoanParamsAdded(
        address indexed loanAddr,
        uint principalTokenIndex,
        uint principalAmount,
        uint interestRate,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount
    );

    constructor(address _loanFactory, address _termsContract) public {
        loanFactory = _loanFactory;
        termsContract = _termsContract;
    }

    //TODO: only authorized contracts, aka funded Crowdloans during submission, should be able to call this. 
    function add(
        address loanAddr,
        uint principalTokenIndex,
        uint principalAmount,
        uint interestRate,
        uint amortizationUnitType,
        uint termLengthInAmortizationUnits,
        uint gracePeriodInAmortizationUnits,
        uint gracePeriodPaymentAmount,
        uint standardPaymentAmount
    ) public returns (uint) {

        uint index = paramCount;

        StudentLoanParams memory params = StudentLoanParams({
            principalTokenIndex: principalTokenIndex,
            principalAmount: principalAmount,
            interestRate: interestRate,
            amortizationUnitType: amortizationUnitType,
            termLengthInAmortizationUnits: termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits: gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount: gracePeriodPaymentAmount,
            standardPaymentAmount: standardPaymentAmount
        });

        paramRegistry[index] = params;
        paramCount++;

        emit LoanParamsAdded(
            loanAddr,
            principalTokenIndex,
            principalAmount,
            interestRate,
            amortizationUnitType,
            termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits,
            gracePeriodPaymentAmount,
            standardPaymentAmount
        );

        return index;
    }

    function get(uint index) public returns(StudentLoanParams memory) {
        return paramRegistry[index];
    }

}