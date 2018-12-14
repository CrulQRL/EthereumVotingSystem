pragma solidity 0.4.24;

contract Election {

    mapping(address => bool) private admins;

    // Constructor
    constructor () public {
        // Add address admin
        addAdmin(0x040834eeDb2b6Ec8E749D6d1eE07B9e0d3149169);
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