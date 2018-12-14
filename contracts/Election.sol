pragma solidity ^0.4.24;

contract Election {

    mapping(address => bool) private admins;
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct User{
        uint id;
        address userAddress;
    }
    
    // Store Candidates Count
    uint public candidatesCount;
    // Store Voting End Time
    uint public endTime;

    // Constructor
    constructor () public {
        // Add address admin
        addAdmin(0xa59dC7F06CB5ed4E1Dd474A74751076611fd4f3F);
        addCandidate("Candidate dummy 1");
        addCandidate("Candidate dummy 2");
        setEndTime(2000000000);
        addUser(0x4AE71950b1DCC2AF3E78BB887dfC7CC47cc353dc);
        addUser(0xeb2e0c694a8B885a1B6a044B6FAE7BE8DE4459ef);
        addUser(0x46a9fAE1468A753543756233d143e42A500560e4);
    }

    // --------- Add Candidate Stuff ---------

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;
    // Store accounts that have voted
    mapping(address => bool) public voters;

    function addCandidate (string _name) public {
        // yang add harus admin
        require(admins[msg.sender] == true);

        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // ------------- ADD USER STUFF ----------------

    uint public userCount;
    mapping(uint => User) public users;

    function addUser (address _userAddress) public {
        userCount ++;
        users[userCount] = User(userCount, _userAddress);
    }
    // ----------------------------------------------

    function addAdmin (address _userAddress) private {
        admins[_userAddress] = true;
    }

    function checkRole () constant public returns(uint role){
        // Lakukan penpm ngecekan apakah user merupakan admin atau bukan
        // msg.sender isinya address dari pemanggil
        // role bernilai 1 untuk admin dan 2 untuk user
        if(admins[msg.sender] == true) {
            role = 1;
        } else {
            role = 2;
        }
    }

    function setEndTime (uint end) private {
        endTime = end;
    }

    function isVotingEnd () view public returns (bool result){
        if(block.timestamp <= endTime) {
            return true;
        } else {
            return false;
        }
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }

}