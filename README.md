# Smart Contracts
All of the Crypt's smart contracts

## Configuring Hardhat
You'll need to add your private key to the Fuji network in the `.env` file.

The other thing we need to take into consideration is how we're going to ensure that our contracts are upgradeable.

We'll need to separate our contracts into:
* Mutable
* Immutable

## Mutable
* IFO

## Immutable
* Airdrop

10,000,000


## FUJI
Some interesting aspects here are that I've left in two important pieces:
* Minting
* Burning

These could prove controversial if the project picks up momentum. I've left burning in there in case the IFO doesn't reach it's allocated percentage.

Whereas I've left the minting in there in case things change. I believe the Minting has the potential to be very tricky. Hence I think that should be the first proposal we put up to Governance.

### Multisig
I'm going to use [Protofire's Gnosis Safe deploy](https://github.com/protofire/avalanche-gnosis-safe-proxy-deploy)

There's currently an issue through the Web UI with Avalanche on Metamask. I'm also having an issue with Protofire's Proxy deploy. I'm busy debugging at the moment.

### Airdrop
Before we can activate the Airdrop we have to whitelist all the eligible accounts:


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




