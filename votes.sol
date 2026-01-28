// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Election {
    string[] public electors;
    address public owner;

    uint256 public maxVotes;
    uint256 public totalVotes;
    uint256 public electionEndTime;
    uint256 public currentLeaderID;
    uint256 public leadingVotes;

    bool public activeVoting;

    mapping(address => bool) public userVotes;
    mapping(uint256 => uint256) public numberOfVotes;

    event Voted(uint256 _index, address _voter);
    event Message(string _message);

    error OnlyOwnerAllowed();
    error ElectorDoesNotExist(uint256 _pickedElector, uint256 _totalElectors);
    error OwnerCantVote();
    error CantVoteTwice();
    error MaxVotesReached(uint256 _maxVotes);
    error VotingIsOver();
    error VotingIsNotOver();
    error MaxVotesCantDecrease();
    error MustBeLater();
    error NoVotesFound();

    constructor(
        string[] memory _electors,
        uint256 _maxVotes,
        uint256 _durationInSeconds
    ) {
        electors = _electors;
        maxVotes = _maxVotes;
        electionEndTime = block.timestamp + _durationInSeconds;
        owner = msg.sender;
        activeVoting = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, OnlyOwnerAllowed());
        _;
    }

    modifier onlyWhileActive() {
        require(activeVoting == true, VotingIsOver());
        _;
    }

    function vote(uint256 _number) public onlyWhileActive {
        require(!userVotes[msg.sender], CantVoteTwice());
        require(
            _number < electors.length,
            ElectorDoesNotExist(_number, electors.length)
        );
        require(block.timestamp < electionEndTime, VotingIsOver());
        require(msg.sender != owner, OwnerCantVote());
        require(totalVotes < maxVotes, MaxVotesReached(maxVotes));

        userVotes[msg.sender] = true;
        numberOfVotes[_number] += 1;
        totalVotes += 1;

        if (numberOfVotes[_number] > leadingVotes) {
            leadingVotes = numberOfVotes[_number];
            currentLeaderID = _number;
        }
        if (totalVotes == maxVotes) {
            activeVoting = false;
        }
        emit Voted(_number, msg.sender);
    }

    function stopVote() public onlyOwner onlyWhileActive {
        electionEndTime = block.timestamp;
        emit Message("Vote is stopped");
        activeVoting = false;
    }

    function resetMaxVotes(uint256 _newMaxVotes) public onlyOwner {
        require(_newMaxVotes > maxVotes, MaxVotesCantDecrease());
        maxVotes = _newMaxVotes;
        activeVoting = true;
        emit Message("Max votes is resetting");
    }

    function editEndTime(int256 _newEndTime) public onlyOwner {
        if (_newEndTime > 0) {
            electionEndTime += uint256(_newEndTime);
            activeVoting = true;
        } else {
            uint256 reduction = uint256(-_newEndTime);
            if (electionEndTime - reduction < block.timestamp)
                revert MustBeLater();
            electionEndTime -= reduction;
        }
        emit Message("EndTime edited");
    }

    function getLeader() public view returns (string memory) {
        require(
            block.timestamp > electionEndTime || !activeVoting,
            VotingIsNotOver()
        );
        require(leadingVotes != 0, NoVotesFound());

        return electors[currentLeaderID];
    }
}
