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
### Create Token
Deploy Token on Remix with the following parameters:
```
The Crypt,RIP,18,10000000,0x63211C6D25Be6ce9b9e058Bd47A70e45A20498ba
```

Some interesting aspects here are that I've left in two important pieces:
* Minting
* Burning

These could prove controversial if the project picks up momentum. I've left burning in there in case the IFO doesn't reach it's allocated percentage.

Whereas I've left the minting in there in case things change. I believe the Minting has the potential to be very tricky. Hence I think that should be the first proposal we put up to Governance.

### Multisig
I'm going to use [Protofire's Gnosis Safe deploy](https://github.com/protofire/avalanche-gnosis-safe-proxy-deploy)

There's currently an issue through the Web UI with Avalanche on Metamask. I'm also having an issue with Protofire's Proxy deploy. I'm busy debugging at the moment.

### Airdrop
When deploying the contract, we need to add some details
```
0x3D0649a8764320649B907cda39242794670653b1,0x63211C6D25Be6ce9b9e058Bd47A70e45A20498ba,0x63211C6D25Be6ce9b9e058Bd47A70e45A20498ba
```

Before we can activate the Airdrop we have to transfer 500,000 RIP to the Contract address of the Airdrop
0x2afBCE6259A249668136765acc95b0f97845791e

At this stage I can just do this via Metamask

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




