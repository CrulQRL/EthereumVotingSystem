module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "172.28.1.1",
      port: 8545,
      network_id: "1" // Match any network id
    }
  }
};
