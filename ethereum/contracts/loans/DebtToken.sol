pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

/*
    A debt token representing a stake in a crowdfunded loan.
    It represents a given percentage of ownership.
*/
contract DebtToken is ERC721Full {
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}