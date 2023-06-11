// TokenizedBallot.sol
pragma solidity ^0.8.0;

contract TokenizedBallot {
    struct Voter {
        uint256 votingPower;
        bool hasVoted;
        uint256 vote;
        address delegate;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    uint256[] public proposals;

    constructor(uint256[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].votingPower = 1;
        voters[chairperson].hasVoted = false;
        proposals = proposalNames;
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only the chairperson can call this function");
        _;
    }

    function giveTokens(address voter, uint256 amount) public onlyChairperson {
        require(!voters[voter].hasVoted, "The voter has already voted");
        voters[voter].votingPower += amount;
    }

    function delegate(address to) public {
        require(voters[msg.sender].votingPower > 0, "You don't have any voting power");
        require(to != msg.sender, "Self-delegation is not allowed");

        address delegateTo = to;
        while (voters[delegateTo].delegate != address(0)) {
            delegateTo = voters[delegateTo].delegate;
            require(delegateTo != msg.sender, "Delegation loop detected");
        }

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].delegate = delegateTo;

        voters[delegateTo].votingPower += voters[msg.sender].votingPower;
    }

    function vote(uint256 proposal) public {
        require(voters[msg.sender].votingPower > 0, "You don't have any voting power");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(proposal < proposals.length, "Invalid proposal");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].vote = proposal;
    }

    function checkVotingPower(address voter) public view returns (uint256 votingPower) {
        votingPower = voters[voter].votingPower;
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
