pragma solidity >=0.4.21 <0.6.0;

// @notice Holds types and constants for student loan data
library StudentLoanTypes {
    struct StoredParams {
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

    struct DerivedParams {
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
}

