// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract voting{

    string[] public electors;

    uint256 public maxVotes;

    uint256 public electionTime;

    


    mapping (address=>uint256) public userVotes;
    mapping (uint256=>uint256) public numberOfVotes;
    mapping (address=>bool) public accessToVote;
    
    constructor(string[] memory _electors, uint256 _maxVotes, uint256 _electionTime){
        electors = _electors;
        maxVotes = _maxVotes;
        electionTime = _electionTime;
    }

    function vote (uint256 _number) public {
        require(_number<electors.length, "number of electors invalid");
        require(accessToVote[msg.sender]==false, "User already vote");
        userVotes[msg.sender]=_number;
        numberOfVotes[_number]+=1;
    }













}