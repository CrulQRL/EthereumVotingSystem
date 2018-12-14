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
        addAdmin(0xB2702B2a9CC41f7a11fE1853fba5470c0733755C);
        addCandidate("Candidate dummy 1");
        addCandidate("Candidate dummy 2");
    }

    // --------- Add Candidate Stuff ---------

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;

    function addCandidate (string _name) public {
        // yang add harus admin
        require(admins[msg.sender] == true);

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
}