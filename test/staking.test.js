const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("staking", function (){
  let owner;
  let acc1;
  let accs;
  let contractNft;
  let contract;
  
  beforeEach(async () => {
    const Token = await ethers.getContractFactory("myNFT");
    [owner, acc1, ...accs] = await ethers.getSigners();
    contractNft = await Token.deploy();
    await contractNft.mintNFTs(1, {value: 100000000})
  });

  beforeEach(async () => {
    const Staking = await ethers.getContractFactory("staking");
    contract = await Staking.deploy(contractNft.address);
    await contract.deployed()
  });
  
  it("Staking time must be right", async () => {
    expect(await contract.SECONDS_TILL_WITHDRAW()).to.eq(2592000);    
  })
  
  it("Reward per block must be right", async () => {
    expect(await contract.REWARD_PER_BLOCK()).to.eq(100000000);
  })
  
  it("Staked amount should be zero", async () => {
    expect(await contract.calculateReward(owner.address)).to.eq(0);
  })
  
  it("isValidator should return FALSE for non-validators", async () => {
    expect(await contract.isValidator(owner.address)).to.be.false
  })
  
  it("calculateReward should be zero", async ()=>{
    expect(await contract.calculateReward(owner.address)).to.eq(0)
  })
  
  it("Should deposit token", async () => {
    const tokenOwner = contractNft.ownerOf(0)
    await contractNft.approve(contract.address, 0, {from: tokenOwner})
    await contract.deposit(0, {from: contractNft.ownerOf(0)})
    expect(await contract.isValidator(tokenOwner)).to.be.true
    expect(await contract.depositedTokens(tokenOwner)).to.be.eq(0)
  });

  it("Should withdraw token", async () => {
    const tokenOwner = contractNft.ownerOf(0)
    await contractNft.approve(contract.address, 0, {from: tokenOwner})
    await contract.deposit(0, {from: tokenOwner})
    await ethers.provider.send("evm_increaseTime", [2592000])
    await contract.withdraw({from: tokenOwner})
    expect(await contract.isValidator(tokenOwner)).to.be.false
  })
})