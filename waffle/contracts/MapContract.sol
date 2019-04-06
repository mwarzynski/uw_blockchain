pragma solidity ^0.5.1;


contract MapContract {

  // Next event simulates returned value from 'iterateNext' function.
  // I don't know why, but I can't read returned values from this method.
  event Next(bytes32, bytes32, bool);

  mapping(bytes32 => bytes32) data;

  mapping(bytes32 => bool) key_exists;
  bytes32[] keys;

  function get(bytes32 key) public view returns (bytes32) {
    return data[key];
  }

  function keyExists(bytes32 key) private view returns (bool) {
    return key_exists[key];
  }

  function set(bytes32 key, bytes32 value) public {
    if (!keyExists(key)) {
      keys.push(key);
      key_exists[key] = true;
    }
    data[key] = value;
  }

  function iterate(uint i) public returns (bytes32, bytes32, bool) {
    if (i >= keys.length) {
      return (0, 0, false);
    }
    bytes32 key = keys[i];
    emit Next(key, data[key], true);
    return (key, data[key], true);
  }

}

