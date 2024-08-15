compile:
	npx hardhat compile

deploy-logic:
	npx hardhat run scripts/deploy-logic.ts --network dbcTestnet

upgrade-logic:
	npx hardhat run scripts/upgrade-logic.ts --network dbcTestnet

verify-logic:
	npx hardhat verify --network dbcTestnet 0x97FF2a3fB3EAD119f38621C92354Dc3491e5B977





