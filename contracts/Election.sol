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

    struct UserStruct {
        bool isVoted;
        uint index;
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
        // Add user address yang bisa voting
        insertUser(0x4AE71950b1DCC2AF3E78BB887dfC7CC47cc353dc);
        insertUser(0xeb2e0c694a8B885a1B6a044B6FAE7BE8DE4459ef);
        insertUser(0xB46189653AF2d1dD2064c45f65C4D4C8D3688aB5);
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

    // ------------- ADD USER STUFF ---------------- //

    mapping(address => UserStruct) private userStructs;
    address[] private userIndex;


    function isUser(address userAddress) public constant returns(bool isRegistered) {
        if(userIndex.length == 0) return false;
        return (userIndex[userStructs[userAddress].index] == userAddress);
    }

    function insertUser(address _userAddress) public {
        require(!isUser(_userAddress));
        userStructs[_userAddress].isVoted = false;
        userStructs[_userAddress].index = userIndex.push(_userAddress) - 1;
    }

    function getUserCount() public constant returns(uint count){
        return userIndex.length;
    }

    function getUserAtIndex(uint index) public constant returns(address, bool){
        address add = userIndex[index];
        return (add, userStructs[add].isVoted);
    }

    // ---------------------------------------------- //

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

    function isVoted(address _userAddress) view public returns (bool isVoted){
        return userStructs[_userAddress].isVoted;
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!userStructs[msg.sender].isVoted);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // cannot vote if is not in voting period
        require(isVotingEnd());

        // record that voter has voted
        userStructs[msg.sender].isVoted = true;
        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }

}