pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../dharma/TermsContract.sol";
import "../dharma/ContractRegistry.sol";


contract StudentLoanTermsContract is TermsContract {
    using SafeMath for uint;

    enum AmortizationUnitType { HOURS, DAYS, WEEKS, MONTHS, YEARS }
    uint public constant NUM_AMORTIZATION_UNIT_TYPES = 5;

    struct StudentLoanParams {
        address principalTokenAddress;
        uint principalAmount;
        uint termStartUnixTimestamp;
        uint termEndUnixTimestamp;
        AmortizationUnitType amortizationUnitType;
        uint termLengthInAmortizationUnits;

        // Given that Solidity does not support floating points, we encode
        // interest rates as percentages scaled up by a factor of 10,000
        // As such, interest rates can, at a maximum, have 4 decimal places
        // of precision.
        uint interestRate;

        uint gracePeriod; // In AmortizationUnits
        uint gracePeriodPaymentAmount;
        uint unitPaymentAmount;
    }

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

    mapping (bytes32 => uint) public valueRepaid;

    ContractRegistry public contractRegistry;

    event LogSimpleInterestTermStart(
        bytes32 indexed agreementId,
        address indexed principalToken,
        uint principalAmount,
        uint interestRate,
        uint indexed amortizationUnitType,
        uint termLengthInAmortizationUnits
    );

    event LogRegisterRepayment(
        bytes32 agreementId,
        address payer,
        address beneficiary,
        uint256 unitsOfRepayment,
        address tokenAddress
    );

    modifier onlyRouter() {
        require(msg.sender == address(contractRegistry.repaymentRouter()));
        _;
    }

    modifier onlyMappedToThisContract(bytes32 agreementId) {
        require(address(this) == contractRegistry.debtRegistry().getTermsContract(agreementId));
        _;
    }

    modifier onlyDebtKernel() {
        require(msg.sender == address(contractRegistry.debtKernel()));
        _;
    }

    constructor(address _contractRegistry) public {
        contractRegistry = ContractRegistry(_contractRegistry);
    }

    function registerTermStart(
        bytes32 agreementId,
        address debtor
    ) public returns (bool _success) {

        // Get Terms contract & parameters from agreement
        address termsContract;
        bytes32 termsContractParameters;

        (termsContract, termsContractParameters) = contractRegistry.debtRegistry().getTerms(agreementId);

        // Parse & Validate parameters
        uint principalTokenIndex;
        uint principalAmount;
        uint interestRate;
        uint amortizationUnitType;
        uint termLengthInAmortizationUnits;

        (principalTokenIndex, principalAmount, interestRate, amortizationUnitType, termLengthInAmortizationUnits) = 
        unpackParametersFromBytes(termsContractParameters);

        address principalTokenAddress = contractRegistry.tokenRegistry().getTokenAddressByIndex(principalTokenIndex);

        // Returns true (i.e. valid) if the specified principal token is valid,
        // the specified amortization unit type is valid, and the terms contract
        // associated with the agreement is this one.  We need not check
        // if any of the other simple interest parameters are valid, because
        // it is impossible to encode invalid values for them.

        // TODO: Validate payments check out to principal + total interest
        if (principalTokenAddress != address(0) && amortizationUnitType < NUM_AMORTIZATION_UNIT_TYPES &&
         termsContract == address(this) && _validateRepaymentSchedule()) {
            emit LogSimpleInterestTermStart(
                agreementId,
                principalTokenAddress,
                principalAmount,
                interestRate,
                amortizationUnitType,
                termLengthInAmortizationUnits
            );

            return true;
        }

        return false;

        

        
    }

    function registerRepayment(
        bytes32 agreementId,
        address payer,
        address beneficiary,
        uint256 unitsOfRepayment,
        address tokenAddress
    ) public returns (bool _success);

    function getExpectedRepaymentValue(
        bytes32 agreementId,
        uint256 timestamp
    ) public view returns (uint256) {

    }

    function getValueRepaidToDate(
        bytes32 agreementId
    ) public view returns (uint256);

    function getTermEndTimestamp(
        bytes32 _agreementId
    ) public view returns (uint);

    /*
        Internal Functions
    */

    function _validateRepaymentSchedule() internal returns (bool) {
        return true;
    }

    function _unpackParamsForAgreementID(bytes32 agreementId) internal returns (StudentLoanParams params)
    {
        bytes32 parameters = contractRegistry.debtRegistry().getTermsContractParameters(agreementId);

        uint principalTokenIndex;
        uint principalAmount;
        uint interestRate;
        uint rawAmortizationUnitType;
        uint termLengthInAmortizationUnits;

        (principalTokenIndex, principalAmount, interestRate, rawAmortizationUnitType, termLengthInAmortizationUnits) =
            _unpackParametersFromBytes(parameters);

        address principalTokenAddress =
            contractRegistry.tokenRegistry().getTokenAddressByIndex(principalTokenIndex);

        // Ensure that the encoded principal token address is valid
        require(principalTokenAddress != address(0));

        // Before we cast to `AmortizationUnitType`, ensure that the raw value being stored is valid.
        require(rawAmortizationUnitType <= uint(AmortizationUnitType.YEARS));

        AmortizationUnitType amortizationUnitType = AmortizationUnitType(rawAmortizationUnitType);

        uint amortizationUnitLengthInSeconds = getAmortizationUnitLengthInSeconds(amortizationUnitType);
        uint issuanceBlockTimestamp = contractRegistry.debtRegistry().getIssuanceBlockTimestamp(agreementId);
        
        uint termLengthInSeconds = termLengthInAmortizationUnits.mul(amortizationUnitLengthInSeconds);
        uint termEndUnixTimestamp = termLengthInSeconds.add(issuanceBlockTimestamp);

        return StudentLoanParams({
            principalTokenAddress: principalTokenAddress,
            principalAmount: principalAmount,
            interestRate: interestRate,
            termStartUnixTimestamp: issuanceBlockTimestamp,
            termEndUnixTimestamp: termEndUnixTimestamp,
            amortizationUnitType: amortizationUnitType,
            termLengthInAmortizationUnits: termLengthInAmortizationUnits
        });
    }

    function getAmortizationUnitLengthInSeconds(AmortizationUnitType amortizationUnitType)
        internal
        pure
        returns (uint _amortizationUnitLengthInSeconds)
    {
        if (amortizationUnitType == AmortizationUnitType.HOURS) {
            return HOUR_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == AmortizationUnitType.DAYS) {
            return DAY_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == AmortizationUnitType.WEEKS) {
            return WEEK_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == AmortizationUnitType.MONTHS) {
            return MONTH_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == AmortizationUnitType.YEARS) {
            return YEAR_LENGTH_IN_SECONDS;
        } else {
            revert();
        }
    }
}

}