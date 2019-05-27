pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/* 
Permanent on-chain record of who staked who. 
Uses events which are indexed off-chain.
*/
contract UserStaking is Ownable {
    event UserStaked(address indexed sender, address indexed recipient);

    constructor() Ownable() public {}

    function stakeUser(address _recipient) public {
        emit UserStaked(msg.sender, _recipient);
    }
}
