import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const contract = '0xc01Ee7f10EA4aF4673cFff62710E1D7792aBa8f3';

  const demo = await ethers.getContractFactory("DemoCoin", deployer);
  const d = demo.attach(contract);

  console.log(`demo name: ${await d.name()}`);
  console.log(`demo symbol: ${await d.symbol()}`);
  console.log(`demo decimals: ${await d.decimals()}`);

  // const code = await ethers.getContractAt("DemoCoin", contract);
  console.log(`code: ${await d.getCode()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
