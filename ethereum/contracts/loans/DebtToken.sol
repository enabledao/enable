pragma solidity ^0.5.2;

// import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";

/*
    A debt token representing a stake in a crowdfunded loan.
    It represents a given percentage of ownership.

    The minter contract has minting rights
*/
contract DebtToken is ERC721Enumerable, ERC721Metadata, ERC721Mintable {

    mapping(uint => uint) private _debtOwned;
    uint private _totalDebt;

    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }

    // Total value of Debt tokens, should total principalAmount upon crowdfund completion
    function totalDebt () public view returns (uint) {
        return _totalDebt;
    }

    function debtValue (uint tokenId) public view returns (uint) {
        return _debtOwned[tokenId];
    }

    /**
     * Mints a unique debt token and inserts the associated issuance into
     * the debt registry, if the calling address is authorized to do so.
     */
    function create(
        address _beneficiary,
        uint _amount
    )
        public
        onlyMinter
        returns (uint _tokenId)
    {
        _tokenId = totalSupply();
        _mint(_beneficiary, _tokenId);
        _debtOwned[_tokenId] = _amount;
        _totalDebt = _totalDebt.add(_amount);
    }

    function remove(
        address _owner,
        uint _tokenId
    )
        public
        onlyMinter
        returns (bool)
    {
        uint _amount =  _debtOwned[_tokenId];
        delete(_debtOwned[_tokenId]);
        _totalDebt = _totalDebt.sub(_amount);
        _burn(_owner, _tokenId);
    }
    // balanceOf (address)
}
