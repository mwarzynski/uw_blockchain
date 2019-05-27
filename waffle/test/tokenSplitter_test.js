const chai = require('chai');
const {createMockProvider, deployContract, getWallets, solidity} = require('ethereum-waffle');
const BasicTokenMock = require('../build/BasicTokenMock');
const TokenSplitter = require('../build/TokenSplitter');

chai.use(solidity);
const {expect} = chai;

describe('Splitter', () => {
  let provider = createMockProvider();
  let [wallet, wallet1, wallet2] = getWallets(provider);

  beforeEach(async () => {
    token = await deployContract(wallet, BasicTokenMock, [wallet.address, 1000]);
    splitter = await deployContract(wallet, TokenSplitter, []);
    expect(await token.balanceOf(wallet.address)).to.eq(1000);
    expect(await token.balanceOf(wallet1.address)).to.eq(0);
    expect(await token.balanceOf(wallet2.address)).to.eq(0);
  });

  it('Can transfer to 1 recipient (not split, but still a valid usage)', async () => {
    await token.approve(splitter.address, 1000);
    await splitter.Split(token.address, [wallet1.address]);
    expect(await token.balanceOf(wallet.address)).to.eq(0);
    expect(await token.balanceOf(wallet1.address)).to.eq(1000);
  });

  it('Can split equally to two recipients', async () => {
   await token.approve(splitter.address, 1000);
    await splitter.Split(token.address, [wallet1.address, wallet2.address]);
    expect(await token.balanceOf(wallet.address)).to.eq(0);
    expect(await token.balanceOf(wallet1.address)).to.eq(500);
    expect(await token.balanceOf(wallet2.address)).to.eq(500);
  });

  it('Cant split in case of 0 recipients', async () => {
    await token.approve(splitter.address, 1000);
    await expect(splitter.Split(token.address, [])).to.be.reverted;
  });

  it('Cant split 1 token with 2 recipients', async () => {
    await token.approve(splitter.address, 1);
    await expect(splitter.Split(token.address, [wallet1.address, wallet2.address])).to.be.reverted;
  });

  it('Cant split 3 tokens with 2 recipients', async () => {
    await token.approve(splitter.address, 3);
    await expect(splitter.Split(token.address, [wallet1.address, wallet2.address])).to.be.reverted;
  });

  it('Cant split when sender didnt approve', async () => {
    await expect(splitter.Split(token.address, [wallet1.address, wallet2.address])).to.be.reverted;
  });

});
