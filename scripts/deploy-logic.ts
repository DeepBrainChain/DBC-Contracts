import dotenv from 'dotenv';
const { ethers, upgrades } = require("hardhat");


dotenv.config();

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log(`deployer address: ${await deployer.getAddress()}`);
    console.log(`deployer balance: ${await deployer.getBalance()}`);

    const contractFactory = await ethers.getContractFactory("Logic",deployer);
    const contract = await upgrades.deployProxy(contractFactory, { initializer: 'initialize' });

    console.log("deployed to:", contract.address);
    // console.log(" getImplementationAddress: ",await upgrades.erc1967.getImplementationAddress(contract.address));
    // console.log(" getAdminAddress: ",await upgrades.erc1967.getAdminAddress(contract.address))
}

main();