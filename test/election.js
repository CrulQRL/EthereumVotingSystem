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

  it("check if vote time is over", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      electionInstance.setEndTime(50)
      return electionInstance.isVotingEnd()
    }).then(function(result) {
      assert.equal(result, true, "Voting period is over");
      electionInstance.setEndTime(5000000000)
      return electionInstance.isVotingEnd()
    }).then(function(result) {
      assert.equal(result, false, "Voting period isn't over yet");
    })
  });
});