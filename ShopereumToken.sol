pragma solidity 0.4.24;

import "./BurnableToken.sol";
import "./Ownable.sol";


/**
 * The Smart contract for Shopereum Token. Based on OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity
 */
contract ShopereumToken is BurnableToken {

  string public name = "Shopereum Token V1.0";
  string public symbol = "xShop";
  uint8 public decimals = 8;

  constructor(uint initialBalance) public {
    _mint(msg.sender, initialBalance);
  }
}