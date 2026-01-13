
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;	

contract SimpleStorage {
    struct UserData{
        string name;
        uint256 age;
        bool man;
    }
    
    
    mapping (address => UserData) public users;
 
    
    function setUsersData (string memory _name, uint256 _age, bool _man) public {
        users[msg.sender]= UserData(_name, _age, _man);
    }

    function getUsersName () public view returns(string memory) {
        return users[msg.sender].name;
    }


}
