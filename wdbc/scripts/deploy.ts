import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`account: ${deployer.address}`);

  const weth = await ethers.getContractFactory("WDBC", deployer);
  const res = await weth.deploy();

  console.log('WDBC address: ' + res.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
