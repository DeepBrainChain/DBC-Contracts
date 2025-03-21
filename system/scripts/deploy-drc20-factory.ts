import dotenv from 'dotenv';
const { ethers, upgrades } = require("hardhat");


dotenv.config();

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log(`deployer address: ${await deployer.getAddress()}`);
    console.log(`deployer balance: ${await deployer.getBalance()}`);

    const contractFactory = await ethers.getContractFactory("DRC20Factory",deployer);
    const contract = await contractFactory.deploy()
    console.log("deployed at:", contract.address);
}

main();