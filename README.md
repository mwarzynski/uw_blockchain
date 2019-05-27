# Task 1

Add validation at `addPoints` function for `_student` parameter.
It must not contain people that are not members of the course.

# Task 2

Implement a contract that will provide functions of a map(bytes32 => bytes32) with a feature to iterate over keys.

# Task 3

Token splitter.

```sol
// waffle/contracts/TokenSplitter.sol

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
```

Tests:

```
  Splitter
    ✓ Can transfer to 1 recipient (not split, but still a valid usage) (246ms)
    ✓ Can split equally to two recipients (196ms)
    ✓ Cant split in case of 0 recipients (92ms)
    ✓ Cant split 1 token with 2 recipients (166ms)
    ✓ Cant split 3 tokens with 2 recipients (121ms)
    ✓ Cant split when sender didnt approve (71ms)

  6 passing (2s)
```

