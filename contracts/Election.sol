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
        addAdmin(0xE8298B645Ee95e099e12542d9be6F6f9bC93627D);
        addCandidate("Candidate dummy 1");
        addCandidate("Candidate dummy 2");
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

    function addAdmin (address _userAddress) private {
        admins[_userAddress] = true;
    }

    function checkRole () view public returns(uint role){
        // Lakukan penpm ngecekan apakah user merupakan admin atau bukan
        // msg.sender isinya address dari pemanggil
        // role bernilai 1 untuk admin dan 2 untuk user
        if(admins[msg.sender] == true) {
            role = 1;
        } else {
            role = 2;
        }
    }

    function setEndTime (uint end) public {
        // yang add harus admin
        require(admins[msg.sender] == true);

        endTime = end;
    }

    function isVotingEnd () view public returns (bool result){
        if(block.timestamp > endTime) {
            // Waktu voting telah habis
            return true;
        } else {
            // Waktu voting belum habis
            return false;
        }
    }

    function vote (uint _candidateId) view public {
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