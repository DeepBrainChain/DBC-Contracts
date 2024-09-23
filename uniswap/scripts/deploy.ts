import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`account: ${deployer.address}`);

  const factory = await ethers.getContractFactory("UniswapV3Factory", deployer);
  const res = await factory.deploy();

  console.log('UniswapV3Factory address: ' + res.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
