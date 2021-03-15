// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
require('dotenv').config();

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // Creating the Token
  const CoinToken = await hre.ethers.getContractFactory("CoinToken");
  const coinToken = await CoinToken.deploy("Crypt","RIP","18","10000000",process.env.FUJI_MULTISIG); 
  await coinToken.deployed();
  console.log("Token deployed to:", coinToken.address);


  const Airdrop = await hre.ethers.getContractFactory("Airdrop");
  const airdrop = await Airdrop.deploy(coinToken.address,process.env.FUJI_MULTISIG,process.env.FUJI_MULTISIG)
  await airdrop.deployed();
  console.log("Airdrop deployed to:", airdrop.address);
  // TODO: Transferring 500,000 RIP to the Airdrop address
  //await token.transfer();


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
