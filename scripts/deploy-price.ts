import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`account: ${deployer.address}`);

  const price = await ethers.getContractFactory("Price", deployer);
  const res = await price.deploy();

  console.log('price address: ' + res.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
