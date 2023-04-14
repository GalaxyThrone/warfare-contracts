import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: process.env.RPC,
      accounts: process.env.PK !== undefined ? [process.env.PK] : [],
      blockGasLimit: 20000000,
    },
  },
};

export default config;
