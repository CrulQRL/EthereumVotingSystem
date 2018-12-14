pragma solidity 0.4.24;

contract Election {

    mapping(address => bool) private admins;
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    // Store Candidates Count
    uint public candidatesCount;
    // Store Voting End Time
    uint public endTime;

    // Constructor
    constructor () public {
        // Add address admin
        addAdmin(0x040834eeDb2b6Ec8E749D6d1eE07B9e0d3149169);
        addCandidate("Candidate dummy 1");
        addCandidate("Candidate dummy 2");
        setEndTime(2000000000);
    }

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;

    function addCandidate (string _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function addAdmin (address _userAddress) private {
        admins[_userAddress] = true;
    }

    function checkRole () constant public returns(uint role){
        // Lakukan pengecekan apakah user merupakan admin atau bukan
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

}