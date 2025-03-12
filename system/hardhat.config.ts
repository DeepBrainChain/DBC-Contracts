import { HardhatUserConfig, task } from "hardhat/config";
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-waffle';
import "@nomiclabs/hardhat-etherscan";
import '@openzeppelin/hardhat-upgrades';

import * as dotenv from "dotenv";
dotenv.config();

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 20000
      }
    }
  },
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545',
      accounts: {
        mnemonic: process.env.MNEMONIC || 'bottom drive obey lake curtain smoke basket hold race lonely fit walk',
        path: "m/44'/60'/0'/0",
      },
      chainId: 19850818
    },
    'dbc-testnet': {
      url: 'https://rpc-testnet.dbcwallet.io',
      accounts: {
        mnemonic: process.env.MNEMONIC || '',
      },
      chainId: 19850818,
      timeout: 600000,
      gasMultiplier: 4,

    },
    'dbc-mainnet': {
      url: 'https://rpc.dbcwallet.io',
      accounts: [process.env.PRIVATE_KEY],
      chainId: 19880818,
      timeout: 600000,
    },
    'bsc-testnet':{
      url: process.env.BSC_TESTNET_RPC_URL,
      chainId: 97,
      accounts: [process.env.BSC_PRIVATE_KEY],
    },
    bsc: {
      url: process.env.BSC_RPC_URL,
      accounts: [process.env.BSC_PRIVATE_KEY],
      chainId: 56,
    }
  },
  etherscan: {
    apiKey: {
      'dbc-testnet': 'no-api-key-needed',
      'dbc-mainnet': 'no-api-key-needed',
    },
    customChains: [
      {
        network: "dbc-testnet",
        chainId: 19850818,
        urls: {
          apiURL: "https://testnet.dbcscan.io/api",
          browserURL: "https://testnet.dbcscan.io",
        },
      },
      {
        network: "dbc-mainnet",
        chainId: 19880818,
        urls: {
          apiURL: "https://www.dbcscan.io/api",
          browserURL: "https://www.dbcscan.io",
        },
      },
    ],
  }
};

export default config;
