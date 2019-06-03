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

import "./DebtRegistry.sol";
import "./TermsContract.sol";
import "./TokenTransferProxy.sol";

/**
 * The RepaymentRouter routes allowers payers to make repayments on any
 * given debt agreement in any given token by routing the payments to
 * the debt agreement's beneficiary.  Additionally, the router acts
 * as a trusted oracle to the debt agreement's terms contract, informing
 * it of exactly what payments have been made in what quantity and in what token.
 *
 * Authors: Jaynti Kanani -- Github: jdkanani, Nadav Hollander -- Github: nadavhollander
 */
contract RepaymentRouter {
    DebtRegistry public debtRegistry;
    TokenTransferProxy public tokenTransferProxy;

    /**
     * Given an agreement id, routes a repayment
     * of a given ERC20 token to the debt's current beneficiary, and reports the repayment
     * to the debt's associated terms contract.
     */
    function repay(
        bytes32 agreementId,
        uint256 amount,
        address tokenAddress
    )
        public
        returns (uint _amountRepaid);
}
