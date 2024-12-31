import dotenv from 'dotenv';
import { upgrades } from 'hardhat';
const { ethers } = require("hardhat");
dotenv.config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const contractFactory = await ethers.getContractFactory("Multisig",deployer);
  const contract = await upgrades.deployProxy(contractFactory,[[process.env.SIGNER1,process.env.SIGNER2,process.env.SIGNER3],process.env.REQUIRED_APPROVE_COUNT,process.env.DELAY_SECONDS], { initializer: 'initialize' });

  console.log("deployed to:", contract.address);
}

main();