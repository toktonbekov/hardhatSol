const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  const [signer] = await ethers.getSigners();
  const myNFT = await ethers.getContractFactory("myNFT", signer);
  const mynft = await myNFT.deploy();
  await mynft.deployed();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
