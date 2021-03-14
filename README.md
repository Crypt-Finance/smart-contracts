# smart-contracts
All of the Crypt's smart contracts

Currently we are deploying via Remix, although as we grow we'll need to migrate to Hardhat. 

# Runsheet
* Create Token
* Transfer to

## Create Token
Deploy Token on Remix with the following parameters:
`“The Crypt”,”RIP”,18,10000000,0x72C397908Cb93d1B569BBB0Ff8d3D26B7b21d730`

Some interesting aspects here are that I've left in two important pieces
* Minting
* Burning

These could prove controversial if the project picks up momentum. I've left burning in there in case the IFO doesn't reach it's allocated percentage.

Whereas I've left the minting in there in case things change. I believe the Minting has the potential to be very tricky. Hence I think that should be the first proposal we put up to Governance.

# Multisig
I'm going to use [Protofire's Gnosis Safe deploy](https://github.com/protofire/avalanche-gnosis-safe-proxy-deploy)

# Airdrop
Deploying the contract
So I have the Airdrop contract on Remix

So I have the contract up on Remix

When deploying the contract, we need to add some details

Testnet

So we can now deploy this contract to the Testnet

Before we can activate the Airdrop we have to transfer 500,000 RIP to the Contract address of the Airdrop
0x69520E8C06Da214118696d49AC6098C2a0829462 

Before we can activate the Airdrop we have to whitelist all the eligible accounts:

So let’s say we want to attract 500 people, that means they all get 1000 RIP tokens which is enough to submit a will. It also means the airdrop will get gobbled up pretty quickly and result in FOMO.

So let’s whitelist the address
0x63211C6D25Be6ce9b9e058Bd47A70e45A20498ba,  

Now we’re ready to activate the Airdrop!

Click the magic button!
0x8524a463e51e00fd775066847e2de3a3eeb675b44139277b351330845a7b6dab

Claiming the Airdrop

Vesting contracts
We’ve got to put three vesting contracts into place
One for me
One for Lynton
One for the release schedule

So for me and Lynt, it will work as follows:
250,000 after Year 1
500,000 after Year 2
750,000 after Year 3

Then in terms of the release of funds into the wild, it will allow the following vesting
After 1 year, 1,000,000
After 2 years, 1,000,000
After 3 years, 1,000,000
FAfter 4 years, 1,000,000
After 5 years 1,000,000

I’m going to use this contract https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/drafts/TokenVesting.sol 
It’s over a year old, but it should be safe enough for now. Let’s hope we don’t get rekt.

It’s a ballache deploying the Open Zeppelin contracts through Remix as they have so many dependencies. So in Test I’m going to use a simpler vesting schedule
Credentials




