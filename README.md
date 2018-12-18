# EthereumVotingSystem
A dApp for voting using Ethereum. An ethereum private network deployment using docker is also here (with automated smart contract migration).

## Prerequisites
- Install `docker` and `docker-compose`
- Install `metamask` extension in chrome for injecting web3 identity

## Configuration
- Modify `contracts/Election.sol` in the constructor part and change the `addAdmin` argument to your own ethereum address for admin access in the evote system.
- Modify `docker/genesis.json` and add your ethereum address to receive ether in the `alloc` field so you can simulate transactions. Ex: 
  ```
  "0x373F339C91fD95FEA40eB86F9F9981770CA9300a": {"balance": "100000"}
  ```
  IMPORTANT: Don't delete the existing alloc address of 0x373F339C91fD95FEA40eB86F9F9981770CA9300a, because the address is used for initializing the smart contract automatically when the ethereum network is started which consumes ether (if you want to really delete it, then configure the files in `docker` specifically account.txt and password.txt to use your selected address, and also change the address reference in `docker-compose.yaml` as well.)

## Starting Up
- Run `docker-compose up --build`. Use `docker-compose down -v && docker-compose up --build` if you want to hard reset the blockchain with new `docker/genesis.json` or `contracts/Election.sol` configuration.
- Access the webserver at `localhost:3000` with metamask installed (and point the network to localhost:8545) and you will see the UI depending on your role in the smart contract (voter/admin/non-voter).

## Shutting Down
- Run `docker-compose down`

## Permanently Deleting the Blockchain volumes
- Run `docker-compose down -v`