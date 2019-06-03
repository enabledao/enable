pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";

/*
    A debt token representing a stake in a crowdfunded loan.
    It represents a given percentage of ownership.
    
    The minter contract has minting rights
*/
contract DebtToken is ERC721, ERC721Enumerable, ERC721Metadata, ERC721Mintable {
        constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}