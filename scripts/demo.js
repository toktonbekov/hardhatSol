const hre = require("hardhat");

async function main() {
  const [signer] = await hre.ethers.getSigners();
  console.log(await signer.getBalance());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
