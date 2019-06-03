/*

  Copyright 2017 Dharma Labs Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.2;

/**
 * The DebtToken contract governs all business logic for making a debt agreement
 * transferable as an ERC721 non-fungible token.  Additionally, the contract
 * allows authorized contracts to trigger the minting of a debt agreement token
 * and, in turn, the insertion of a debt issuance into the DebtRegsitry.
 *
 * Author: Nadav Hollander -- Github: nadavhollander
 */
contract DebtToken {

    /**
     * ERC165 interface.
     * Returns true for ERC721, false otherwise
     */
    function supportsInterface(bytes4 interfaceID)
        external
        view
        returns (bool _isSupported);

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
        returns (uint _tokenId);

    /**
     * Adds an address to the list of agents authorized to mint debt tokens.
     */
    function addAuthorizedMintAgent(address _agent)
        public;

    /**
     * Removes an address from the list of agents authorized to mint debt tokens
     */
    function revokeMintAgentAuthorization(address _agent)
        public;
    /**
     * Returns the list of agents authorized to mint debt tokens
     */
    function getAuthorizedMintAgents()
        public
        view
        returns (address[] memory _agents);

    /**
     * Adds an address to the list of agents authorized to set token URIs.
     */
    function addAuthorizedTokenURIAgent(address _agent)
        public;

    /**
     * Returns the list of agents authorized to set token URIs.
     */
    function getAuthorizedTokenURIAgents()
        public
        view
        returns (address[] memory _agents);

    /**
     * Removes an address from the list of agents authorized to set token URIs.
     */
    function revokeTokenURIAuthorization(address _agent)
        public;

    /**
     * We override approval method of the parent ERC721Token
     * contract to allow its functionality to be frozen in the case of an emergency
     */
    function approve(address _to, uint _tokenId)
        public;
    /**
     * We override setApprovalForAll method of the parent ERC721Token
     * contract to allow its functionality to be frozen in the case of an emergency
     */
    function setApprovalForAll(address _to, bool _approved)
        public;

    /**
     * Support deprecated ERC721 method
     */
    function transfer(address _to, uint _tokenId)
        public;

    /**
     * We override transferFrom methods of the parent ERC721Token
     * contract to allow its functionality to be frozen in the case of an emergency
     */
    function transferFrom(address _from, address _to, uint _tokenId)
        public;

    /**
     * We override safeTransferFrom methods of the parent ERC721Token
     * contract to allow its functionality to be frozen in the case of an emergency
     */
    function safeTransferFrom(address _from, address _to, uint _tokenId)
        public;

    /**
     * We override safeTransferFrom methods of the parent ERC721Token
     * contract to allow its functionality to be frozen in the case of an emergency
     */
    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes memory _data)
        public;

    /**
     * Allows senders with special permissions to set the token URI for a given debt token.
     */
    function setTokenURI(uint256 _tokenId, string memory _uri)
        public;

}
