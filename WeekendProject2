// Ballot.sol
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 vote;
        address delegate;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    uint256[] public proposals;

    constructor(uint256[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].isRegistered = true;
        voters[chairperson].hasVoted = false;
        proposals = proposalNames;
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only the chairperson can call this function");
        _;
    }

    function giveRightToVote(address voter) public onlyChairperson {
        require(!voters[voter].isRegistered, "The voter is already registered");
        voters[voter].isRegistered = true;
        voters[voter].hasVoted = false;
    }

    function delegate(address to) public {
        require(voters[msg.sender].isRegistered, "You are not a registered voter");
        require(to != msg.sender, "Self-delegation is not allowed");

        address delegateTo = to;
        while (voters[delegateTo].delegate != address(0)) {
            delegateTo = voters[delegateTo].delegate;
            require(delegateTo != msg.sender, "Delegation loop detected");
        }

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].delegate = delegateTo;

        if (voters[delegateTo].hasVoted) {
            proposals[voters[delegateTo].vote] += 1;
        }
    }

    function vote(uint256 proposal) public {
        require(voters[msg.sender].isRegistered, "You are not a registered voter");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(proposal < proposals.length, "Invalid proposal");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].vote = proposal;

        proposals[proposal] += 1;
    }

    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i] > winningVoteCount) {
                winningVoteCount = proposals[i];
                winningProposal_ = i;
            }
        }
    }
}
