compile:
	npx hardhat compile

deploy-logic:
	npx hardhat run scripts/deploy-logic.ts --network dbc-testnet

upgrade-logic:
	npx hardhat run scripts/upgrade-logic.ts --network dbc-testnet

verify-logic:
	source .env && npx hardhat verify --network dbc-testnet $LOGIC_CONTRACT_PROXY_CONTRACT
	source .env && npx hardhat verify --network dbc-mainnet $LOGIC_CONTRACT_PROXY_CONTRACT

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

deploy-batch-transfer-dbc:
	npx hardhat run scripts/deploy-batch-transfer.ts --network dbc-mainnet

upgrade-batch-transfer-bsc:
	npx hardhat run scripts/upgrade-batch-transfer.ts --network dbc-mainnet

verify-batch-transfer-bsc:
	source .env && npx hardhat verify --network dbc-mainnet $BATCH_TRANSFER_PROXY_CONTRACT


deploy_multisig-dbc-testnet:
	source .env && npx hardhat run scripts/deploy_multisig.ts --network dbc-testnet

verify_deploy_multisig-dbc-testnet:
	source .env && npx hardhat verify --network dbc-testnet $MULTI_SGIN_TIME_LOCK_CONTRACT

upgrade_deploy_multisig-dbc-testnet:
	npx hardhat run scripts/upgrade_multisig.ts --network dbc-testnet


deploy_multi_sign_time_lock-dbc-mainnet:
	source .env && npx hardhat run scripts/deploy_multisig.ts --network dbc-mainnet

verify_multi_sign_time_lock-dbc-mainnet:
	source .env && npx hardhat verify --network dbc-mainnet $MULTI_SGIN_TIME_LOCK_CONTRACT

upgrade_multi_sign_time_lock-dbc-mainnet:
	npx hardhat run scripts/upgrade_multisig.ts --network dbc-mainnet

deploy_ai-dbc-testnet:
	npx hardhat run scripts/deploy-ai.ts --network dbc-testnet

verify_ai-dbc-testnet:
	source .env && npx hardhat verify --network dbc-testnet $AI_PROXY_CONTRACT
	source .env && npx hardhat verify --network dbc-mainnet $AI_PROXY_CONTRACT


upgrade_ai-dbc-testnet:
	npx hardhat run scripts/upgrade-ai.ts --network dbc-testnet

deploy-drc20-factory-testnet:
	npx hardhat run scripts/deploy-drc20-factory.ts --network dbc-testnet

verify-drc20-factory-testnet:
	source .env && npx hardhat verify --network dbc-testnet $DRC20_FACTORY_CONTRACT

deploy-drc20-factory-mainnet:
	npx hardhat run scripts/deploy-drc20-factory.ts --network dbc-mainnet

verify-drc20-factory-mainmet:
	source .env && npx hardhat verify --network dbc-mainnet $DRC20_FACTORY_CONTRACT

verify-drc20-testnet:
	source .env && npx hardhat verify --network dbc-testnet $DRC20_CONTRACT $DRC20_OWNER $DRC20_NAME $DRC20_SYMBOL $DRC20_SUPPLY

verify-drc20-mainmet:
	source .env && npx hardhat verify --network dbc-mainnet $DRC20_CONTRACT $DRC20_OWNER $DRC20_NAME $DRC20_SYMBOL $DRC20_SUPPLY


