import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const contract = '0x3ed62137c5DB927cb137c26455969116BF0c23Cb';

  const bridge = await ethers.getContractFactory("Bridge", deployer);
  const c = bridge.attach(contract);

  const res = await c.transfer("0x72d2a933cf76922656a65ca44cf83dd2e680a996a0fca20042c52307784c4955", ethers.utils.parseEther("1"));
  console.log(`result: ${JSON.stringify(res)}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
