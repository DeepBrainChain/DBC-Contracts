compile:
	npx hardhat compile

deploy-logic:
	npx hardhat run scripts/deploy-logic.ts --network dbc-testnet

upgrade-logic:
	npx hardhat run scripts/upgrade-logic.ts --network dbc-testnet

verify-logic:
	source .env && npx hardhat verify --network dbc-testnet $LOGIC_CONTRACT_PROXY_CONTRACT

deploy-register:
	npx hardhat run scripts/deploy-register.ts --network dbc-testnet

upgrade-register:
	npx hardhat run scripts/upgrade-register.ts --network dbc-testnet

verify-register:
	source .env && npx hardhat verify --network dbc-testnet $REGISTER_CONTRACT_PROXY_CONTRACT

deploy-batch-transfer:
	npx hardhat run scripts/deploy-batch-transfer.ts --network dbc-testnet

upgrade-batch-transfer:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network dbc-testnet

verify-batch-transfer:
	source .env && npx hardhat verify --network dbc-testnet $BATCH_TRANSFER_PROXY_CONTRACT

deploy-batch-transfer-bsc-testnet:
	npx hardhat run scripts/deploy-batch-transfer.ts --network bsc-testnet

upgrade-batch-transfer-bsc-testnet:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network bsc-testnet

verify-batch-transfer-bsc-testnet:
	source .env && npx hardhat verify --network bsc-testnet $BATCH_TRANSFER_PROXY_CONTRACT

deploy-batch-transfer-bsc:
	npx hardhat run scripts/deploy-batch-transfer.ts --network bsc

upgrade-batch-transfer-bsc:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network bsc

verify-batch-transfer-bsc:
	source .env && npx hardhat verify --network bsc $BATCH_TRANSFER_PROXY_CONTRACT




