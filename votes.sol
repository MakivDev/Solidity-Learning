// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Election {
    string[] public electors;
    address public owner;

    uint256 public maxVotes;
    uint256 public totalVotes;
    uint256 public electionEndTime;
    uint256 public startTime;

    mapping(address => bool) public userVotes;
    mapping(uint256 => uint256) public numberOfVotes;

    error OnlyOwnerAllowed();
    error ElectorDoesNotExist(uint256 _pickedElector, uint256 _totalElectors);
    error OwnerCantVote();
    error CantVoteTwice();
    error MaxVotesReached(uint256 _maxVotes);
    error VotingIsOver();
    error VotingIsNotOver();
    error MaxVotesCantDecrease();
    error MustBeLater();

    constructor(
        string[] memory _electors,
        uint256 _maxVotes,
        uint256 _durationInSeconds
        
    ) {
        startTime = block.timestamp;
        electors = _electors;
        maxVotes = _maxVotes;
        electionEndTime = block.timestamp + _durationInSeconds;
        owner = msg.sender;
    }

    function vote(uint256 _number) public {
        require(userVotes[msg.sender] == false, CantVoteTwice());
        require(_number < electors.length, ElectorDoesNotExist(_number, electors.length));
        require(totalVotes < maxVotes, MaxVotesReached(maxVotes));
        require(block.timestamp < electionEndTime, VotingIsOver());
        require(msg.sender != owner, OwnerCantVote());

        userVotes[msg.sender] = true;
        numberOfVotes[_number] += 1;
        totalVotes += 1;
    }

    modifier  onlyOwner(){
        require(msg.sender == owner, OnlyOwnerAllowed());
        _;
    }


    function stopVote() public onlyOwner {
        electionEndTime = block.timestamp;
    }

    function resetMaxVotes(uint256 _newMaxVotes) public onlyOwner  {
        require(_newMaxVotes > maxVotes, MaxVotesCantDecrease());
        maxVotes = _newMaxVotes;
    }

    function resetEndTime (uint256 _newEndTime) public onlyOwner  {
        require(_newEndTime>block.timestamp, MustBeLater());
        electionEndTime = startTime + _newEndTime;
    }


    function getLeader () public view returns(string memory){
        require(block.timestamp>electionEndTime, VotingIsNotOver());
        
        uint256 winnerID;

        for(uint256 i=0; i<electors.length; i++){
            if(numberOfVotes[i]>winnerID){
                winnerID=i;
            }
        }
        return electors[winnerID];
    }





}