pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./DebtToken.sol";

contract DebtTokenFactory is Ownable {
    
    function createDebtToken(string memory _name, string memory _symbol) public returns (address) {
        DebtToken token = new DebtToken(_name, _symbol);
        return address(token);
    }
}