pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "../../dharma-interface/TermsContract.sol";
import "../../dharma-interface/ContractRegistry.sol";
import "../../core/EnableContractRegistry.sol";

import "./StudentLoanTermsStorage.sol";
import "./StudentLoanLibrary.sol";


contract StudentLoanTermsContract is TermsContract {
    using SafeMath for uint;
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;
    using StudentLoanLibrary for StudentLoanLibrary.AmortizationUnitType;

    /*
        Storage Variables
    */

    mapping (bytes32 => uint) public valueRepaid; //This tracks the valuerepaid for every agreement that uses this contract.

    ContractRegistry public dharmaContractRegistry;
    EnableContractRegistry public enableContractRegistry;
    StudentLoanTermsStorage public termsStorage;

    /*
        Events
    */

    event LogStudentLoanTermStart(
        bytes32 agreementId,
        address tokenAddress
    );

    event LogRegisterRepayment(
        bytes32 agreementId,
        address payer,
        address beneficiary,
        uint256 unitsOfRepayment,
        address tokenAddress
    );

    /*
        Modifiers
    */

    modifier onlyRouter() {
        require(msg.sender == address(dharmaContractRegistry.repaymentRouter()));
        _;
    }

    modifier onlyMappedToThisContract(bytes32 agreementId) {
        require(address(this) == dharmaContractRegistry.debtRegistry().getTermsContract(agreementId));
        _;
    }

    modifier onlyDebtKernel() {
        require(msg.sender == address(dharmaContractRegistry.debtKernel()));
        _;
    }

    /*
        Constructor
    */

    constructor(
        address _dharmaContractRegistry,
        address _enableContractRegistry,
        address _termsStorage
    ) public {
        dharmaContractRegistry = ContractRegistry(_dharmaContractRegistry);
        enableContractRegistry = EnableContractRegistry(_enableContractRegistry);
        termsStorage = StudentLoanTermsStorage(_termsStorage);
    }

    /*
        Public Functions
    */

    function registerTermStart(bytes32 agreementId, address debtor) public returns (bool _success) {

        // Get Terms contract & parameters from agreement
        address termsContract;
        bytes32 termsContractParameters;

        (termsContract, termsContractParameters) = dharmaContractRegistry.debtRegistry().getTerms(agreementId);

        // TODO: Parse stored parameters
        StudentLoanLibrary.StoredParams memory params = termsStorage.get(unpackParameters(termsContractParameters));

        // TODO: Find t oken address & validiate
        // Returns true (i.e. valid) if the specified principal token is valid,
        // the specified amortization unit type is valid, and the terms contract
        // associated with the agreement is this one.  We need not check
        // if any of the other simple interest parameters are valid, because
        // it is impossible to encode invalid values for them.
        
        address principalTokenAddress = dharmaContractRegistry.tokenRegistry().getTokenAddressByIndex(params.principalTokenIndex);

        // TODO: Validate payments check out to principal + total interest
        if (
            principalTokenAddress != address(0) && 
            params.amortizationUnitType < StudentLoanLibrary.NUM_AMORTIZATION_UNIT_TYPES && 
            termsContract == address(this) && 
            _validateRepaymentSchedule()
        ) {
            //TODO: Add params to log start
            emit LogStudentLoanTermStart(
                agreementId,
                principalTokenAddress
            );

            return true;
        }

        return false;
    }

     /// When called, the registerRepayment function records the debtor's
     ///  repayment, as well as any auxiliary metadata needed by the contract
     ///  to determine ex post facto the value repaid (e.g. current USD
     ///  exchange rate)
     /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
     /// @param  payer address. The address of the payer.
     /// @param  beneficiary address. The address of the payment's beneficiary.
     /// @param  unitsOfRepayment uint. The units-of-value repaid in the transaction.
     /// @param  tokenAddress address. The address of the token with which the repayment transaction was executed.
    function registerRepayment(bytes32 agreementId, address payer, address beneficiary, uint256 unitsOfRepayment, address tokenAddress) public onlyRouter returns (bool _success) {
        StudentLoanLibrary.StoredParams memory params = _unpackParamsForAgreementID(agreementId);

        if (tokenAddress == params.principalTokenAddress) {
            valueRepaid[agreementId] = valueRepaid[agreementId].add(unitsOfRepayment);

            LogRegisterRepayment(
                agreementId,
                payer,
                beneficiary,
                unitsOfRepayment,
                tokenAddress
            );

            return true;
        }

        return false;
    }

    function getExpectedRepaymentValue(bytes32 agreementId, uint256 timestamp) public view onlyMappedToThisContract(agreementId) returns (uint256 _expectedRepaymentValue) {
        StudentLoanLibrary.StoredParams memory params = _unpackParamsForAgreementID(agreementId);
        uint principalPlusInterest = _calculateTotalPrincipalPlusInterest(params);

        if (timestamp <= params.termStartUnixTimestamp) {
            /* The query occurs before the contract was even initialized so the
            expected value of repayments is 0. */
            return 0;
        } else if (timestamp >= params.termEndUnixTimestamp) {
            /* the query occurs beyond the contract's term, so the expected
            value of repayment is the full principal plus interest. */
            return principalPlusInterest;
        } else {

            uint numUnits = _numAmortizationUnitsForTimestamp(timestamp, params);
            uint gracePeriodUnits;
            uint standardUnits;
            
            //Math.min
            if (numUnits <= params.gracePeriodInAmortizationUnits) {
                gracePeriodUnits = numUnits;
                standardUnits = 0;
            } else if ( numUnits > params.gracePeriodInAmortizationUnits) {
                gracePeriodUnits = params.gracePeriodInAmortizationUnits;           
                standardUnits = numUnits.sub(gracePeriodUnits);           
            }

            uint gracePeriodAmountDue = gracePeriodUnits.mul(params.gracePeriodPaymentAmount);
            uint standardAmountDue = standardUnits.mul(params.standardPaymentAmount);

            return gracePeriodAmountDue.add(standardAmountDue);
        }   
    }

    function getValueRepaidToDate(bytes32 agreementId) public view returns (uint256);

    function getTermEndTimestamp(bytes32 _agreementId) public view returns (uint);

    /*
        Internal Functions
    */

    function _validateRepaymentSchedule() internal returns (bool) {
        return true;
    }

    function _unpackParamsForAgreementID(bytes32 agreementId) internal returns (StudentLoanLibrary.StoredParams memory params)
    {
        bytes32 parameters = dharmaContractRegistry.debtRegistry().getTermsContractParameters(agreementId);
        
        // TODO: Bit-shift to get index in storage
        // TODO: Extract stored parameters
        uint principalTokenIndex;
        uint principalAmount;
        uint rawAmortizationUnitType;
        uint termLengthInAmortizationUnits;
        uint gracePeriodInAmortizationUnits;
        uint gracePeriodPaymentAmount;
        uint standardPaymentAmount;
        uint interestRate;

        (principalTokenIndex, principalAmount, interestRate, rawAmortizationUnitType, termLengthInAmortizationUnits, 
        gracePeriodInAmortizationUnits, gracePeriodPaymentAmount, standardPaymentAmount) =
            unpackParameters(parameters);
        
        // TODO: Calculate derived parameters
        address principalTokenAddress =
            dharmaContractRegistry.tokenRegistry().getTokenAddressByIndex(principalTokenIndex);

        require(principalTokenAddress != address(0)); // Ensure that the encoded principal token address is valid
        require(rawAmortizationUnitType <= uint(StudentLoanLibrary.AmortizationUnitType.YEARS)); // Before we cast to `StudentLoanLibrary.AmortizationUnitType`, ensure that the raw value being stored is valid.

        StudentLoanLibrary.AmortizationUnitType amortizationUnitType = StudentLoanLibrary.AmortizationUnitType(rawAmortizationUnitType);

        uint amortizationUnitLengthInSeconds = _getAmortizationUnitLengthInSeconds(amortizationUnitType);
        uint issuanceBlockTimestamp = dharmaContractRegistry.debtRegistry().getIssuanceBlockTimestamp(agreementId);

        uint termLengthInSeconds = termLengthInAmortizationUnits.mul(amortizationUnitLengthInSeconds);
        uint termEndUnixTimestamp = termLengthInSeconds.add(issuanceBlockTimestamp);

        uint gracePeriodInSeconds = gracePeriodInAmortizationUnits.mul(amortizationUnitLengthInSeconds);
        uint gracePeriodEndUnixTimeStamp = gracePeriodInSeconds.add(issuanceBlockTimestamp);

        return StudentLoanLibrary.StoredParams({
            principalTokenAddress: principalTokenAddress,
            principalAmount: principalAmount,
            termStartUnixTimestamp: issuanceBlockTimestamp,
            termEndUnixTimestamp: termEndUnixTimestamp,
            amortizationUnitType: amortizationUnitType,
            termLengthInAmortizationUnits: termLengthInAmortizationUnits,
            gracePeriodInAmortizationUnits: gracePeriodInAmortizationUnits,
            gracePeriodEndUnixTimestamp: gracePeriodEndUnixTimeStamp,
            gracePeriodPaymentAmount: gracePeriodPaymentAmount,
            standardPaymentAmount: standardPaymentAmount,
            interestRate: interestRate
        });
    }

    function unpackParameters(bytes32 parameters) public pure returns (uint _storageIndex) {
        // The firt 22 of the parameters encodes the index of the parameters in storage (The rest is reserved for the Dharma Collateralizer)
        bytes32 principalTokenIndexShifted =
            parameters & 0xfffffffffffffffffffffffffffffffffffff000000000000000000000000000;

        // Note that the remaining 108 bits are reserved for any parameters relevant to a
        // collateralized terms contracts.

        /*
        We then bit shift left each of these values so that the 32-byte uint
        counterpart correctly represents the value that was originally packed
        into the 32 byte string.
        The below chart summarizes where in the 32 byte string each value
        terminates -- which indicates the extent to which each value must be bit
        shifted left.
                                        Location (bytes)	Location (bits)
                                        32                  256
        principalTokenIndex	            31	                248
        principalAmount	                19                  152
        interestRate                    16                  128
        amortizationUnitType            15.5                124
        termLengthInAmortizationUnits   13.5                108
        */
        return (_bitShiftRight(principalTokenIndexShifted, 248));
    }

    /**
     * Calculates the total repayment value expected at the end of the loan's term.
     *
     * This computation assumes that interest is paid per amortization period.
     *
     * @param params StudentLoanParams. The parameters that define the loan.
     * @return uint The total repayment value expected at the end of the loan's term.
     */
    function _calculateTotalPrincipalPlusInterest(StudentLoanLibrary.StoredParams memory params) internal returns (uint _principalPlusInterest) {
        // Since we represent decimal interest rates using their
        // scaled-up, fixed point representation, we have to
        // downscale the result of the interest payment computation
        // by the multiplier scaling factor we choose for interest rates.
        uint totalInterest = params.principalAmount
            .mul(params.interestRate)
            .div(StudentLoanLibrary.INTEREST_RATE_SCALING_FACTOR_MULTIPLIER);

        return params.principalAmount.add(totalInterest);
    }

    function _numAmortizationUnitsForTimestamp(uint timestamp, StudentLoanLibrary.StoredParams memory params) internal returns (uint units) {
        uint delta = timestamp.sub(params.termStartUnixTimestamp);
        uint amortizationUnitLengthInSeconds = _getAmortizationUnitLengthInSeconds(params.amortizationUnitType);
        return delta.div(amortizationUnitLengthInSeconds);
    }

    function _getAmortizationUnitLengthInSeconds(StudentLoanLibrary.AmortizationUnitType amortizationUnitType)
        internal
        pure
        returns (uint _amortizationUnitLengthInSeconds)
    {
        if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.HOURS) {
            return StudentLoanLibrary.HOUR_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.DAYS) {
            return StudentLoanLibrary.DAY_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.WEEKS) {
            return StudentLoanLibrary.WEEK_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.MONTHS) {
            return StudentLoanLibrary.MONTH_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.YEARS) {
            return StudentLoanLibrary.YEAR_LENGTH_IN_SECONDS;
        } else {
            revert();
        }
    }
    
    function _bitShiftRight(bytes32 value, uint amount) internal pure returns (uint) {
        return uint(value) / 2 ** amount;
    }
}
