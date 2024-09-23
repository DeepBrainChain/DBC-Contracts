import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const contract = '0x3d3593927228553b349767ABa68d4fb1514678CB';

  const weth = await ethers.getContractFactory("UniswapV3Factory", deployer);
  const d = weth.attach(contract);

  const res = await d.setOwner('0x0000000000000000000000000000000000000000');
  console.log(res);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
