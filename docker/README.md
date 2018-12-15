# Deploying the Ethereum Private Blockchain

## Prerequisites
- Modify `volume/genesis.json` and add your ethereum address to receive ether in the `alloc` field. Ex: 
  ```
  "0x373F339C91fD95FEA40eB86F9F9981770CA9300a": {"balance": "100000"}
  ```
- Install `docker` and `docker-compose`

## Starting Up
- Run `docker-compose up -d`. If for some reason one of the miners failed to start because of volume mounting problems, run the command again. Use `docker-compose down -v && docker-compose up -d` if you want to hard reset the blockchain with new `volume/genesis.json` configuration.

## Shutting Down
- Run `docker-compose down`

## Permanently Deleting the Blockchain
- Run `docker-compose down -v`