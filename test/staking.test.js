const { expect } = require("chai");
const { ethers } = require("hardhat");
// import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("staking", function (){

  let contract;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async () => {
    const Staking = await ethers.getContractFactory("staking",addr1);
    [ addr1, addr2, ...addrs] = await ethers.getSigners();
    contract = await Staking.deploy("0xdD2FD4581271e230360230F9337D5c0430Bf44C0");
    await contract.deployed()
  });


  it("Staking time must be right", async () => {
      expect(await contract.SECONDS_TILL_WITHDRAW()).to.eq(2592000);
  })

  it("Reward per block must be right", async () => {
    expect(await contract.REWARD_PER_BLOCK()).to.eq(100000000);
    })

  it("Staked amount should be zero", async () => {
    expect(await contract.calculateReward(addr1.address)).to.eq(0);
  })

  it("isValidator should return FALSE for non-validators", async () => {
    expect(await contract.isValidator(addr1.address)).to.be.false
  })

  it("calculateReward should be zero", async ()=>{
    expect(await contract.calculateReward(addr1.address)).to.eq(0)
  })

})
