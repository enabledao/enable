pragma solidity ^0.5.2;

/**
 * The TokenRegistry is a basic registry mapping token symbols
 * to their known, deployed addresses on the current blockchain.
 *
 * Note that the TokenRegistry does *not* mediate any of the
 * core protocol's business logic, but, rather, is a helpful
 * utility for Terms Contracts to use in encoding, decoding, and
 * resolving the addresses of currently deployed tokens.
 *
 * At this point in time, administration of the Token Registry is
 * under Dharma Labs' control.  With more sophisticated decentralized
 * governance mechanisms, we intend to shift ownership of this utility
 * contract to the Dharma community.
 */
contract TokenRegistry {
    /**
     * Maps the given symbol to the given token attributes.
     */
    function setTokenAttributes(
        string memory _symbol,
        address _tokenAddress,
        string memory _tokenName,
        uint8 _numDecimals
    )
        public;

    /**
     * Given a symbol, resolves the current address of the token the symbol is mapped to.
     */
    function getTokenAddressBySymbol(string memory _symbol) public view returns (address);

    /**
     * Given the known index of a token within the registry's symbol list,
     * returns the address of the token mapped to the symbol at that index.
     *
     * This is a useful utility for compactly encoding the address of a token into a
     * TermsContractParameters string memory -- by encoding a token by its index in a
     * a 256 slot array, we can represent a token by a 1 byte uint instead of a 20 byte address.
     */
    function getTokenAddressByIndex(uint _index) public view returns (address);

    /**
     * Given a symbol, resolves the index of the token the symbol is mapped to within the registry's
     * symbol list.
     */
    function getTokenIndexBySymbol(string memory _symbol) public view returns (uint);

    /**
     * Given an index, resolves the symbol of the token at that index in the registry's
     * token symbol list.
     */
    function getTokenSymbolByIndex(uint _index) public view returns (string memory);
    /**
     * Given a symbol, returns the name of the token the symbol is mapped to within the registry's
     * symbol list.
     */
    function getTokenNameBySymbol(string memory _symbol) public view returns (string memory);

    /**
     * Given the symbol for a token, returns the number of decimals as provided in
     * the associated TokensAttribute struct.
     *
     * Example:
     *   getNumDecimalsFromSymbol("REP");
     *   => 18
     */
    function getNumDecimalsFromSymbol(string memory _symbol) public view returns (uint8);

    /**
     * Given the index for a token in the registry, returns the number of decimals as provided in
     * the associated TokensAttribute struct.
     *
     * Example:
     *   getNumDecimalsByIndex(1);
     *   => 18
     */
    function getNumDecimalsByIndex(uint _index) public view returns (uint8);

    /**
     * Given the index for a token in the registry, returns the name of the token as provided in
     * the associated TokensAttribute struct.
     *
     * Example:
     *   getTokenNameByIndex(1);
     *   => "Canonical Wrapped Ether"
     */
    function getTokenNameByIndex(uint _index) public view returns (string memory);

    /**
     * Given the symbol for a token in the registry, returns a tuple containing the token's address,
     * the token's index in the registry, the token's name, and the number of decimals.
     *
     * Example:
     *   getTokenAttributesBySymbol("WETH");
     *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", 1, "Canonical Wrapped Ether", 18]
     */
    function getTokenAttributesBySymbol(string memory _symbol)
        public
        view
        returns (
            address,
            uint,
            string memory,
            uint
        );

    /**
     * Given the index for a token in the registry, returns a tuple containing the token's address,
     * the token's symbol, the token's name, and the number of decimals.
     *
     * Example:
     *   getTokenAttributesByIndex(1);
     *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", "WETH", "Canonical Wrapped Ether", 18]
     */
    function getTokenAttributesByIndex(uint _index)
        public
        view
        returns (
            address,
            string memory,
            string memory,
            uint8
        );
}
