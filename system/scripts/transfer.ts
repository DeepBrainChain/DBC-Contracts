import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`deployer address: ${await deployer.getAddress()}`);
  console.log(`deployer balance: ${await deployer.getBalance()}`);

  const tx = await deployer.sendTransaction({
	to: '0x92d3267215Ec56542b985473E73C8417403B15ac',
	value: ethers.utils.parseUnits('0.001', 'ether'),
  });
  console.log(tx);

  console.log(`deployer balance: ${await deployer.getBalance()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
