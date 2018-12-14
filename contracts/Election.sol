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

    // Constructor
    constructor () public {
        // Add address admin
        addAdmin(0x040834eeDb2b6Ec8E749D6d1eE07B9e0d3149169);
        addCandidate("Candidate dummy 1");
        addCandidate("Candidate dummy 2");
    }

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;
    // Store accounts that have voted
    mapping(address => bool) public voters;

    function addCandidate (string _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

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

    function vote () constant public returns(uint _candidateId) {
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