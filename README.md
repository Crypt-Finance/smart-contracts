# Smart Contracts
All of the Crypt's smart contracts

## Deploying The Cryp
You'll need to add your credentials to the `.env` file.

```bash
npm install
npm run fujitime01
```

* Transfer 500,000 from Multisig wallet to Airdrop address. So you'll need to add the newly created TOKEN to Metamask and then transfer to the newly created Airdrop address.
* Transfer the funds into the FoundersVesting
* Transfer the funds into the TokenReleaseSchedule

```bash
npm install
npm run fujitime01
```


We'll need to separate our contracts into:
* Mutable
* Immutable

## Mutable
* IFO

## Immutable
* Airdrop

10,000,000


## Notes
Some interesting aspects here are that I've left in two important pieces:
* Minting
* Burning

These could prove controversial if the project picks up momentum. I've left burning in there in case the IFO doesn't reach it's allocated percentage.

Whereas I've left the minting in there in case things change. I believe the Minting has the potential to be very tricky. Hence I think that should be the first proposal we put up to Governance.

### Multisig
I'm going to use [Protofire's Gnosis Safe deploy](https://github.com/protofire/avalanche-gnosis-safe-proxy-deploy)

There's currently an issue through the Web UI with Avalanche on Metamask. I'm also having an issue with Protofire's Proxy deploy. I'm busy debugging at the moment.
