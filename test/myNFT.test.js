const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("myNFT", function (){
  let contract;
  let owner;
  let addr1;
  let addr2;
  let addrs;
  let baseURI;

  beforeEach(async () => {
    const Token = await ethers.getContractFactory("myNFT");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    contract = await Token.deploy();
    baseURI = "https://hardhat.org/test/"
    await contract.setBaseURI(baseURI)
  });

  it("Should initialize contract", async () => {
    expect(await contract.MAX_NFTS()).to.eq(10000);
    console.log(contract.address);
  });
  it("Should set the right owner", async () => {
    expect(await contract.owner()).to.eq(await owner.address);
  });
  it("Should mint", async () => {
    const price = await contract.getPrice();
    const tokenId = await contract.totalSupply();
    expect(
      await contract.mintNFTs(1, {
        value: price,
      })
    ).to.emit(contract, "Transfer").withArgs(ethers.constants.AddressZero, owner.address, tokenId);  
    expect(await contract.tokenURI(tokenId)).to.eq(baseURI+"0")
  });
});
