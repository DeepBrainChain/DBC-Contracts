const { ethers, upgrades } = require("hardhat");

async function main() {

    const [deployer] = await ethers.getSigners();
    console.log(`deployer address: ${await deployer.getAddress()}`);
    console.log(`deployer balance: ${await deployer.getBalance()}`);

    const contract = await ethers.getContractFactory("Logic",deployer);

    const r = await upgrades.upgradeProxy(
        process.env.LOGIC_CONTRACT_PROXY_CONTRACT,
        contract,
        {
            gasLimit: 10000000,
        }

);
    await r.deployed()
    console.log("contract upgraded address",r.address);
}

main();