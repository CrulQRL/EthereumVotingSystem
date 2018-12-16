App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Election.json", function(election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Election = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.Election.setProvider(App.web3Provider);

      return App.render();
    });
  },

  createCandidate: function() {
    $("#content").hide();
    $("#loader").show();
    var candidateName = $('#candidateName').val();
    App.contracts.Election.deployed().then(function(instance) {
      console.log(typeof(App.account));
      console.log(App.account);
      return instance.addCandidate(candidateName, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").show();
      $("#loader").hide();
    }).catch(function(err) {
      console.error(err);
    });
  },

  createUser: function() {
    $("#content").hide();
    $("#loader").show();
    var userAddress = $('#userAddress').val().toLowerCase();
    App.contracts.Election.deployed().then(function(instance) {
      return instance.insertUser(userAddress);
    }).then(function(result) {
      // Wait for votes to update
      $("#content").show();
      $("#loader").hide();
    }).catch(function(err) {
      console.error(err);
    });
  },

  revealVote: function () {
    var electionInstance;
    App.contracts.Election.deployed().then(function (instance) {
      electionInstance = instance;
      return electionInstance.isVotingEnd();
    }).then(function(isEnd) {
      if(isEnd) {
        // Tampilim vote user
        return electionInstance.candidatesCount();
      } else {
        $("#reveal-button").hide()
        $(".reveal-candidate").html("The voting period is not ended")
      }
    }).then(function(candidatesCount) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      $(".candidate-tr").append("<th scope='col'> Vote Count </th>")
      $("#reveal-button").hide()
      for (var i = 1; i <= candidatesCount; i++) {
        electionInstance.candidates(i).then(function (candidate) {
          var id = candidate[0];
          var name = candidate[1];
          var voteCount = candidate[2];

          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>"+voteCount+"</td></tr>"
          candidatesResults.append(candidateTemplate);
        });
      }
      
    }).catch(function (error) {
      console.warn(error);
    });
  },

  render: function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      loader.hide();
      content.show();
      return electionInstance.checkRole();
    }).then(function(role) {
      
      if(role.toNumber() == 1){
        // Pindah ke halaman admin
        return electionInstance.candidatesCount();
      }else{
        // Pindah ke halaman user
        window.location.replace("http://localhost:3000/index-user.html");
      }
      
    }).then(function(candidatesCount) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      for (var i = 1; i <= candidatesCount; i++) {
        electionInstance.candidates(i).then(function(candidate) {
          var id = candidate[0];
          var name = candidate[1];
          
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td></tr>"
          candidatesResults.append(candidateTemplate);
        });
      }

      return electionInstance.getUserCount();
    }).then(function(usersCount) {
      var usersResults = $("#usersResults");
      usersResults.empty();
      indexUser = 1;
      for (var i = 0; i < usersCount; i++) {
        electionInstance.getUserAtIndex(i).then(function(user) {
          var address = user[0];
          var isVoted = user[1];
          var userTemplate = "<tr><th>" + indexUser + "</th><td>" + address + "</td><td>" + isVoted + "</td></tr>"
          usersResults.append(userTemplate);
          indexUser++
        });
      }

      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });
  }
};


$(function() {
  $(window).load(function() {
    App.init();
  });
});