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
        addAdmin(0x373F339C91fD95FEA40eB86F9F9981770CA9300a);
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
        setEndTime(1545264000);
    }

    // --------- Add Candidate Stuff ---------

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;

    function addCandidate (string _name) public {
        // yang add harus admin
        require(admins[msg.sender] == true, "Sender is not admin");

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
        require(admins[msg.sender] == true);
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
        require(!admins[_userAddress]);
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

    function getEndTime () public view returns (uint result){
        return endTime;
    }

    function isVotingEnd () public view returns (bool result){
        if(block.timestamp > endTime) {
            // Waktu voting telah habis
            return true;
        } else {
            // Waktu voting belum habis
            return false;
        }
    }

    function hasVoted(address _userAddress) public view returns (bool isVoted){
        return userStructs[_userAddress].isVoted;
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!userStructs[msg.sender].isVoted);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // cannot vote if is not in voting period
        require(!isVotingEnd());

        // record that voter has voted
        userStructs[msg.sender].isVoted = true;
        // update candidate vote Count
        candidates[_candidateId].voteCount ++;
    }

}