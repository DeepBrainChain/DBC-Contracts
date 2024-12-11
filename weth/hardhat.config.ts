import { HardhatUserConfig, task } from "hardhat/config";
import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-waffle';
import "@nomiclabs/hardhat-etherscan";
import '@openzeppelin/hardhat-upgrades';

import * as dotenv from "dotenv";
dotenv.config({ path: '../.env' });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: {
    version: "0.4.18",
    settings: {
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
        mnemonic: process.env.MNEMONIC || '',
        path: "m/44'/60'/0'/0",
      },
      chainId: 19850818
    },
    dbcTestnet: {
      url: 'https://rpc-testnet.dbcwallet.io',
      accounts: {
        mnemonic: process.env.MNEMONIC || '',
      },
      chainId: 19850818,
      timeout: 600000,
    },
    dbcMainnet: {
      url: 'https://rpc.dbcwallet.io',
      accounts: {
        mnemonic: process.env.MNEMONIC || '',
      },
      chainId: 19880818,
      timeout: 600000,
    }
  },
  etherscan: {
    apiKey: {
      dbcTestnet: 'no-api-key-needed',
      dbcMainnet: 'no-api-key-needed',
    },
    customChains: [
      {
        network: "dbcTestnet",
        chainId: 19850818,
        urls: {
          apiURL: "https://testnet.dbcscan.io/api",
          browserURL: "https://testnet.dbcscan.io",
        },
      },
      {
        network: "dbcMainnet",
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
