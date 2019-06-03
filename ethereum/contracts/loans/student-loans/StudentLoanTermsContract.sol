pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "../../dharma-interface/TermsContract.sol";
import "../../dharma-interface/ContractRegistry.sol";

import "./StudentLoanLibrary.sol";


contract StudentLoanTermsContract is TermsContract {
    using SafeMath for uint;
    using StudentLoanLibrary for StudentLoanLibrary.StoredParams;
    using StudentLoanLibrary for StudentLoanLibrary.AmortizationUnitType;
    
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

    /*
        Storage Variables
    */

    mapping (bytes32 => uint) public valueRepaid; //This tracks the valuerepaid for every agreement that uses this contract.

    ContractRegistry public dharmaContractRegistry;

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
        address _dharmaContractRegistry
    ) public {
        dharmaContractRegistry = ContractRegistry(_dharmaContractRegistry);
    }

    /*
        Public Functions
    */

    function registerTermStart(bytes32 agreementId, address debtor) public returns (bool _success);

     /// When called, the registerRepayment function records the debtor's
     ///  repayment, as well as any auxiliary metadata needed by the contract
     ///  to determine ex post facto the value repaid (e.g. current USD
     ///  exchange rate)
     /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
     /// @param  payer address. The address of the payer.
     /// @param  beneficiary address. The address of the payment's beneficiary.
     /// @param  unitsOfRepayment uint. The units-of-value repaid in the transaction.
     /// @param  tokenAddress address. The address of the token with which the repayment transaction was executed.
    function registerRepayment(bytes32 agreementId, address payer, address beneficiary, uint256 unitsOfRepayment, address tokenAddress) public returns (bool _success);

    function getExpectedRepaymentValue(bytes32 agreementId, uint256 timestamp) public view returns (uint256 _expectedRepaymentValue);

    function getValueRepaidToDate(bytes32 agreementId) public view returns (uint256);

    function getTermEndTimestamp(bytes32 _agreementId) public view returns (uint);

    /*
        Internal Functions
    */

    function _validateRepaymentSchedule() internal returns (bool);
    function _getParamsForAgreementID(bytes32 agreementId) internal returns (StudentLoanLibrary.LoanParams memory);

    function unpackIndex(bytes32 parameters) public pure returns (uint _storageIndex);

    /**
     * Calculates the total repayment value expected at the end of the loan's term.
     *
     * This computation assumes that interest is paid per amortization period.
     *
     * @param params StudentLoanParams. The parameters that define the loan.
     * @return uint The total repayment value expected at the end of the loan's term.
     */
    function _calculateTotalPrincipalPlusInterest(StudentLoanLibrary.LoanParams memory params) internal returns (uint _principalPlusInterest);

    function _numAmortizationUnitsForTimestamp(uint timestamp, StudentLoanLibrary.LoanParams memory params) internal pure returns (uint units) {
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
            return HOUR_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.DAYS) {
            return DAY_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.WEEKS) {
            return WEEK_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.MONTHS) {
            return MONTH_LENGTH_IN_SECONDS;
        } else if (amortizationUnitType == StudentLoanLibrary.AmortizationUnitType.YEARS) {
            return YEAR_LENGTH_IN_SECONDS;
        } else {
            revert();
        }
    }
    
    function _bitShiftRight(bytes32 value, uint amount) internal pure returns (uint) {
        return uint(value) / 2 ** amount;
    }
}
