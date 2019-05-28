pragma solidity >=0.4.21 <0.6.0;

// @notice Holds types and constants for student loan data
library StudentLoanLibrary {
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

    struct LoanParams {
        //Stored Params
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

        //Derived Params
        address principalTokenAddress;
        uint termStartUnixTimestamp;
        uint termEndUnixTimestamp;
        uint gracePeriodEndUnixTimestamp;
    }

    enum AmortizationUnitType { HOURS, DAYS, WEEKS, MONTHS, YEARS }
}

