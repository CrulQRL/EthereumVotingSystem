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
    var candidateName = $('#candidateName').val();
    App.contracts.Election.deployed().then(function(instance) {
      return instance.addCandidate(candidateName, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
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

      return electionInstance.userCount();
    }).then(function(usersCount) {
      var usersResults = $("#usersResults");
      usersResults.empty();

      for (var i = 1; i <= usersCount; i++) {
        electionInstance.users(i).then(function(user) {
          var id = user[0];
          var address = user[1];
          electionInstance.voters(address).then(function(isVoted) {
            var userTemplate = "<tr><th>" + id + "</th><td>" + address + "</td><td>" + isVoted + "</td></tr>"
            usersResults.append(userTemplate);
          });
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