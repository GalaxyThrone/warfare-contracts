import { ethers, upgrades } from "hardhat";
import { addShips } from "./addShipTypes";

async function main() {
  const Ships = await ethers.getContractFactory("Ships");
  const ships = await upgrades.deployProxy(Ships, [
    ethers.constants.AddressZero,
  ]);
  await ships.deployed();

  const Game = await ethers.getContractFactory("Game");
  const game = await upgrades.deployProxy(Game, [ships.address]);
  await game.deployed();

  await ships.setGame(game.address);

  console.log("Game deployed to:", game.address);
  console.log("Ships deployed to:", ships.address);

  await addShips(ships.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
