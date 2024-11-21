compile:
	npx hardhat compile

deploy-logic:
	npx hardhat run scripts/deploy-logic.ts --network dbcTestnet

upgrade-logic:
	npx hardhat run scripts/upgrade-logic.ts --network dbcTestnet

verify-logic:
	source .env && npx hardhat verify --network dbcTestnet $LOGIC_CONTRACT_PROXY_CONTRACT

deploy-register:
	npx hardhat run scripts/deploy-register.ts --network dbcTestnet

upgrade-register:
	npx hardhat run scripts/upgrade-register.ts --network dbcTestnet

verify-register:
	source .env && npx hardhat verify --network dbcTestnet $REGISTER_CONTRACT_PROXY_CONTRACT

deploy-batch-transfer:
	npx hardhat run scripts/deploy-batch-transfer.ts --network dbcTestnet

upgrade-batch-transfer:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network dbcTestnet

verify-batch-transfer:
	source .env && npx hardhat verify --network dbcTestnet $BATCH_TRANSFER_PROXY_CONTRACT

deploy-batch-transfer-bsc-testnet:
	npx hardhat run scripts/deploy-batch-transfer.ts --network bscTestnet

upgrade-batch-transfer-bsc-testnet:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network bscTestnet

verify-batch-transfer-bsc-testnet:
	source .env && npx hardhat verify --network bscTestnet $BATCH_TRANSFER_PROXY_CONTRACT






