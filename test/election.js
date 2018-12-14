var Election = artifacts.require("./Election.sol");

contract("Election", function(accounts) {
  var electionInstance;

  it("Check user role is Admin", function() {
    return Election.deployed().then(function(instance) {
      return instance.checkRole({ from: "0xb2702b2a9cc41f7a11fe1853fba5470c0733755c" });
    }).then(function(role) {
        assert.equal(role.toNumber(), 1);
    });
  });

  it("initializes with two candidates", function() {
    return Election.deployed().then(function(instance) {
      return instance.candidatesCount();
    }).then(function(count) {
      assert.equal(count.toNumber(), 2);
    });
  });

  it("it initializes the candidates with the correct values", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.candidates(1);
    }).then(function(candidate) {
      assert.equal(candidate[0].toNumber(), 1, "contains the correct id");
      assert.equal(candidate[1], "Candidate dummy 1", "contains the correct name");
      assert.equal(candidate[2].toNumber(), 0, "contains the correct votes count");
      return electionInstance.candidates(2);
    }).then(function(candidate) {
      assert.equal(candidate[0].toNumber(), 2, "contains the correct id");
      assert.equal(candidate[1], "Candidate dummy 2", "contains the correct name");
      assert.equal(candidate[2].toNumber(), 0, "contains the correct votes count");
    });
  });

  it("initializes with three users", function() {
    return Election.deployed().then(function(instance) {
      return instance.userCount();
    }).then(function(count) {
      assert.equal(count.toNumber(), 3);
    });
  });

  it("it initializes the users with the correct values", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.users(accounts[1]);
    }).then(function(candidate) {
      assert.equal(1, 1, "contains the correct id");
    })
  });

});