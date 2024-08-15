const { ethers, upgrades } = require("hardhat");

async function main() {
    const contract = await ethers.getContractFactory("Logic");

    const r = await upgrades.upgradeProxy(
        process.env.LOGIC_CONTRACT_PROXY_CONTRACT,
        contract
    );
    console.log("contract upgraded impl address",r.address);
}

main();