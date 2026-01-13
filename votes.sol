// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract voting {
    string[] public electors;

    uint256 public maxVotes;
    uint256 public electionTime;

    bool public validVote;

    address public owner;

    mapping(address => uint256) public userVotes;
    mapping(uint256 => uint256) public numberOfVotes;
    mapping(address => bool) public accessToVote;

    constructor(
        string[] memory _electors,
        uint256 _maxVotes,
        uint256 _electionTime
    ) {
        electors = _electors;
        maxVotes = _maxVotes;
        electionTime = block.timestamp + _electionTime;
        validVote = true;
        owner = msg.sender;
    }

    function vote(uint256 _number) public {
        require(_number < electors.length, "number of electors invalid");
        require(accessToVote[msg.sender] == false, "User already vote");
        require(
            validVote == true,
            "everyone already have max vote or vote stopped by owner"
        );
        require(msg.sender != owner, "owner cant vote");
        require(electionTime > block.timestamp, "time out");

        userVotes[msg.sender] = _number;
        numberOfVotes[_number] += 1;

        accessToVote[msg.sender] = true;

        if (numberOfVotes[_number] >= maxVotes) {
            validVote = false;
        }
    }

    function stopVote() public {
        require(msg.sender == owner, "you not owner");

        validVote = false;
    }
}
