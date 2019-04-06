const chai = require('chai');
const {createMockProvider, deployContract, getWallets, solidity} = require('ethereum-waffle');
const MapContract = require('../build/MapContract');
const {utils} = require('ethers');


chai.use(solidity);
const {expect} = chai;

function b32(text) {
    var result = utils.hexlify(utils.toUtf8Bytes(text));
    while (result.length < 66) { result += '0'; }
    if (result.length !== 66) { throw new Error("invalid web3 implicit bytes32"); }
    return result;
}

describe('MapContract', () => {
  let provider = createMockProvider();
  let [wallet, _] = getWallets(provider);
  let token;

  beforeEach(async () => {
    token = await deployContract(wallet, MapContract, []);
  });
    
  // Implement a contract that will provide functions of a map (bytes32 => bytes32) with a feature to iterate over keys.
  it('Can provide a function of a map (bytes32 => bytes32) with a feature to iterate over map', async () => {
    // Add two values to the Map.
    await token.set(b32("testKey1"), b32("testValue1"));
    await token.set(b32("testKey2"), b32("testValue2"));
    expect(await token.get(b32("testKey1"))).to.eq(b32("testValue1"));
    expect(await token.get(b32("testKey2"))).to.eq(b32("testValue2"));
    // Iterate over the added items and check if we got correct values.
    await token.iterateReset();
    await expect(token.iterateNext(0))
      .to.emit(token, 'Next')
      .withArgs(b32("testKey1"), b32("testValue1"), true);
    await expect(token.iterateNext(1))
      .to.emit(token, 'Next')
      .withArgs(b32("testKey2"), b32("testValue2"), true);
  });
});
