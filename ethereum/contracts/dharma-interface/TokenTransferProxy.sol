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
 * The TokenTransferProxy is a proxy contract for transfering principal
 * and fee payments and repayments between agents and keepers in the Dharma
 * ecosystem.  It is decoupled from the DebtKernel in order to make upgrades to the
 * protocol contracts smoother -- if the DebtKernel or RepyamentRouter is upgraded to a new contract,
 * creditors will not have to grant new transfer approvals to a new contract's address.
 *
 * Author: Nadav Hollander -- Github: nadavhollander
 */
contract TokenTransferProxy {

    /**
     * Return list of agents authorized to initiate `transferFrom` calls
     */
    function getAuthorizedTransferAgents()
        public
        view
        returns (address[] memory authorizedAgents);
    /**
     * Transfer specified token amount from _from address to _to address on give token
     */
    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint _amount
    )
        public
        returns (bool _success);
}
