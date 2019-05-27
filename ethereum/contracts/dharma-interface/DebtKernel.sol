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
 * The DebtKernel is the hub of all business logic governing how and when
 * debt orders can be filled and cancelled.  All logic that determines
 * whether a debt order is valid & consensual is contained herein,
 * as well as the mechanisms that transfer fees to keepers and
 * principal payments to debtors.
 *
 * Author: Nadav Hollander -- Github: nadavhollander
 */
contract DebtKernel {
    mapping (bytes32 => bool) public issuanceCancelled;
    mapping (bytes32 => bool) public debtOrderCancelled;

    ////////////////////////
    // EXTERNAL FUNCTIONS //
    ////////////////////////

    /**
     * Allows contract owner to set the currently used debt token contract.
     * Function exists to maximize upgradeability of individual modules
     * in the entire system.
     */
    function setDebtToken(address debtTokenAddress)
        public;

    /**
     * Fills a given debt order if it is valid and consensual.
     */
    function fillDebtOrder(
        address creditor,
        address[6] memory orderAddresses,
        uint[8] memory orderValues,
        bytes32[1] memory orderBytes32,
        uint8[3] memory signaturesV,
        bytes32[3] memory signaturesR,
        bytes32[3] memory signaturesS
    )
        public
        returns (bytes32 _agreementId);

    /**
     * Allows both underwriters and debtors to prevent a debt
     * issuance in which they're involved from being used in
     * a future debt order.
     */
    function cancelIssuance(
        address version,
        address debtor,
        address termsContract,
        bytes32 termsContractParameters,
        address underwriter,
        uint underwriterRiskRating,
        uint salt
    )
        public;

    /**
     * Allows a debtor to cancel a debt order before it's been filled
     * -- preventing any counterparty from filling it in the future.
     */
    function cancelDebtOrder(
        address[6] memory orderAddresses,
        uint[8] memory orderValues,
        bytes32[1] memory orderBytes32
    )
        public;
}
