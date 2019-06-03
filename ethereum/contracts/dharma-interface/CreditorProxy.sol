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
 * The CreditorProxy is a thin wrapper around the DebtKernel
 * It implements creditor-driven loans as specified by DIP-1
 *
 * Authors: Bo Henderson <bohendo> & Shivani Gupta <shivgupt> & Dharma Team
 * DIP: https://github.com/dharmaprotocol/DIPs/issues/1
 */
contract CreditorProxy {
    /*
     * Submit debt order to DebtKernel if it is consensual with creditor's request
     * Creditor signature in arguments is only used internally,
     * It will not be verified by the Debt Kernel
     */
    function fillDebtOffer(
        address creditor,
        address[6] memory orderAddresses, // repayment-router, debtor, uw, tc, p-token, relayer
        uint[8] memory orderValues, // rr, salt, pa, uwFee, rFee, cFee, dFee, expTime
        bytes32[1] memory orderBytes32, // tcParams
        uint8[3] memory signaturesV, // debtV, credV, uwV
        bytes32[3] memory signaturesR,
        bytes32[3] memory signaturesS
    )
        public
        returns (bytes32 _agreementId);

    /**
     * Allows creditor to prevent a debt offer from being used in the future
     */
    function cancelDebtOffer(
        address[5] memory commitmentAddresses,
        uint[4] memory commitmentValues,
        bytes32[1] memory termsContractParameters
    )
        public;
}
