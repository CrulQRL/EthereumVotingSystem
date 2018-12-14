var Election = artifacts.require("./Election.sol");

contract("Election", function(accounts) {
  var electionInstance;

  it("Check user role is Admin", function() {
    return Election.deployed().then(function(instance) {
      return instance.checkRole({ from: "0x040834eedb2b6ec8e749d6d1ee07b9e0d3149169" });
    }).then(function(role) {
        assert.equal(role.toNumber(), 1);
    });
  });

});