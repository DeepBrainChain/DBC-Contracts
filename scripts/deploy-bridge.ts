import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`account: ${deployer.address}`);

  const bridge = await ethers.getContractFactory("Bridge", deployer);
  const res = await bridge.deploy();

  console.log('bridge address: ' + res.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
