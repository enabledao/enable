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

    mapping(address => uint) private _debtRatio;
    uint private _totalDebt;

    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function totalDebt () public view returns (uint) {
      return _totalDebt;
    }

    /**
     * Mints a unique debt token and inserts the associated issuance into
     * the debt registry, if the calling address is authorized to do so.
     */
    function create(
        address _version,
        address _beneficiary,
        address _debtor,
        address _underwriter,
        uint _underwriterRiskRating,
        address _termsContract,
        bytes32 _termsContractParameters,
        uint _salt
    )
        public
        onlyMinter
        returns (uint _tokenId)
    {

    }


    // balanceOf (address)
}
