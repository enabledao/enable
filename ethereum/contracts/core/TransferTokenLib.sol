pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

// @notice Ensures token amount transferred successfully
library TransferTokenLib {
    using SafeMath for uint;

    function validatedTransferFrom ( IERC20 _token, address _from, address _to, uint _amount ) internal returns (bool) {
          uint balance = _token.balanceOf(_to);
          _token.transferFrom(_from, _to, _amount);
          require(_token.balanceOf(_to) >= balance.add(_amount));
          return true;
    }
}
