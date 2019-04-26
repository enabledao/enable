pragma solidity 0.5.7;

/**
 * @title Bloom account registry
 * @notice Account Registry Logic allows users to link multiple addresses to the same owner
 *
 */

contract IAccountRegistryLogic {
    function linkIds(address _address) public view returns (uint256);
}