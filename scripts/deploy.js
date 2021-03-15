// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
require('dotenv').config();

const airdropRecipients = [
  "0xebc146CC23b0742B603595f8bEA7dABcbF05840A",
  "0x1440B55c5a3722e440eeAAE62fd02ff82Da78F59",
  "0x2Bf5BC87AE8A378833738974B41d696288274443",
  "0xD125D49F04702758aD50A64463576206DBdaC2d4",
  "0x3859Fc2aBe68b16669658368bD6Aece648e7456a",
  "0xebc81492aa41839a81815527054d41FD9Ce0918C",
  "0x0afdaab23c3feab1441f078ad47ed70dfea4fdb6",
  "0x3ea9DD246531cdb4586640F73f6f56037Af328F1",
  "0x9774daC7C89E96b2BE9403AaA9B98dE62B835BbC",
  "0x6a48ec1612221cfa07dae8c340f25520044aa2e0",
  "0xd72225c033592b1447e3a19bf457b949d161740a",
  "0x975474FF64739316c3a4e8E66c791Ce83ca02F38",
  "0x4EA5eF1207DDEA0e4DE4D480fB1a6765C6edb291",
  "0x99eE6D18708fe26192C943897F3d0d7C45b628d8",
  "0xdde0874187a085ee9138793a1825dd2fd13a7d1c",
  "0xD5eD0DC20Bafc45e9B7C18B310934DeF3cFdF723",
  "0x0156a7a5f84449bccdf1c7fcbf52cad8200dc783",
  "0x265401ced8af3e3261491238a86b61405ae3318d",
  "0xd45d35bC22c19a9979184fC146108eaB0B6AD41c",
  "0xB50d78b0C608119ad86cFCEEE2b649392A7E482F",
  "0xc356b22f2f5f08f27AEE64E19eD49873edcA8799",
  "0x5E1DDBF30651D056d744BA2124a1aB9183Cb74C9"
]

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

  // Whitelisting all the Airdrop recipients before activating the Airdrop
  airdrop.whitelistAddresses(airdropRecipients, 1000);

  // Transferring 500,000 RIP to the Airdrop address
  //coinToken.transfer(airdrop.address,500000);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
