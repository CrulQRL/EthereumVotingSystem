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
  it("Check user is registered", function() {
    return Election.deployed().then(function(instance) {
      return instance.isUser("0x4ae71950b1dcc2af3e78bb887dfc7cc47cc353dc");
    }).then(function(isRegistered) {
        assert.equal(isRegistered, true);
    });
  });

  it("allows a voter to cast a vote", function () {
    return Election.deployed().then(function (instance) {
      electionInstance = instance;
      candidateId = 1;
      return electionInstance.vote(candidateId, { from: accounts[0] });
    }).then(function (receipt) {
      return electionInstance.voters(accounts[0]);
    }).then(function (voted) {
      assert(voted, "the voter was marked as voted");
      return electionInstance.candidates(candidateId);
    }).then(function (candidate) {
      var voteCount = candidate[2];
      assert.equal(voteCount, 1, "increments the candidate's vote count");
    })
  });

  it("throws an exception for invalid candidates", function () {
    return Election.deployed().then(function (instance) {
      electionInstance = instance;
      return electionInstance.vote(99, { from: accounts[1] })
    }).then(assert.fail).catch(function (error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
      return electionInstance.candidates(1);
    }).then(function (candidate1) {
      var voteCount = candidate1[2];
      assert.equal(voteCount, 1, "candidate 1 did not receive any votes");
      return electionInstance.candidates(2);
    }).then(function (candidate2) {
      var voteCount = candidate2[2];
      assert.equal(voteCount, 0, "candidate 2 did not receive any votes");
    });
  });

});