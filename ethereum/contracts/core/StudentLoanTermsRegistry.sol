pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../core/StudentLoanTypes.sol";

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
contract StudentLoanTermsRegistry is Ownable {
    mapping (uint => StudentLoamParams) paramRegistry;
    uint paramRegistryCount;

    event LoanParamsAdded(address loanAddr, uint principal);

    //TODO: only authorized contracts, aka funded Crowdloans during submission, should be able to call this. 
    function add(StudentLoamParams params) public {
        paramRegistry[index];
    }

    function get(uint index) public returns(StudentLoanParams) {
        return paramRegistry[index];
    }
}