import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`account: ${deployer.address}`);

  const bridge = await ethers.getContractFactory("Bridge", deployer);
  const res = await upgrades.upgradeProxy("0x3ed62137c5DB927cb137c26455969116BF0c23Cb", bridge);
  await res.deployed();

  console.log('bridge address: ' + res.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
