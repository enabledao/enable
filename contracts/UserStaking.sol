pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./bloominterface/IAccountRegistryLogic.sol";
/* 
Permanent on-chain record of who staked (vouched for the creditworthiness of) whom.
Uses events which are indexed off-chain.
*/
contract UserStaking is Ownable {
    IAccountRegistryLogic accountRegistryLogic;

    event UserStaked(address indexed sender, address indexed recipient);
    event AccountRegistryLogicAddressChanged(address newAddress);

    constructor(address _accountRegistryLogicAddress) Ownable() public {
        accountRegistryLogic = IAccountRegistryLogic(_accountRegistryLogicAddress);
    }

    function stakeUser(address _recipient) public {
        require (accountRegistryLogic.linkIds(_recipient) != 0, "Recipient must be a member of Bloom network");
        require (accountRegistryLogic.linkIds(msg.sender) != 0, "Sender must be a member of Bloom network");
        emit UserStaked(msg.sender, _recipient);
    }

    function setAccountRegistryLogicAddress(address _newAddress) onlyOwner() {
        accountRegistryLogic = IAccountRegistryLogic(_newAddress);
        emit AccountRegistryLogicAddressChanged(_newAddress);
    }
}
