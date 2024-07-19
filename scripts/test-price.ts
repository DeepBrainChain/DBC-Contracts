import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const contract = '0xc01Ee7f10EA4aF4673cFff62710E1D7792aBa8f3';

  const price = await ethers.getContractFactory("Price", deployer);
  const c = price.attach(contract);

  const res1 = await c.getDBCPrice();
  console.log(`result: ${JSON.stringify(res1)}`);

  const res2 = await c.getDBCAmountByValue(ethers.utils.parseEther("1"));
  console.log(`result: ${JSON.stringify(res2)}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
