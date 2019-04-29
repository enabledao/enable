pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract TokenTransfer {
    function _receiveTokens (address _token, address _sender, uint _amount) internal returns (bool) {
      IERC20(_token).transferFrom(_sender, address(this), _amount);
      return true;
    }

    function _sendTokens (address _token, address _receiver, uint _amount) internal returns (bool) {
      IERC20(_token).transfer(_receiver, _amount);
      return true;
    }
}
