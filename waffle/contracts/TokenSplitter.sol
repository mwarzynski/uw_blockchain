pragma solidity ^0.5.1;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract TokenSplitter {
  function Split(ERC20 token, address[] memory recipients) public {
    if (recipients.length == 0) {
      revert("splitting the token to 0 recipients");
    }
    uint256 total_amount = token.balanceOf(msg.sender);
    if ((total_amount % recipients.length) != 0) {
      revert("cannot split tokens equally");
    }
    uint256 each_amount = token.balanceOf(msg.sender) / recipients.length;
    if (each_amount == 0) {
      revert("not enough balance to split");
    }
    for (uint256 i = 0; i < recipients.length; i++) {
      token.transferFrom(msg.sender, recipients[i], each_amount);
    }
  }
}

