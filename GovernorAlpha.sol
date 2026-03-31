// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ITimelock {
    function delay() external view returns (uint);
    function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
}

interface IVotes {
    function getVotes(address account) external view returns (uint256);
}

contract GovernorAlpha is Ownable {
    string public constant name = "Alpha Governance";
    uint public constant quorumVotes = 400000e18; // 4% of supply
    uint public constant proposalThreshold = 100000e18; // 1% of supply
    uint public constant votingPeriod = 17280; // ~3 days in blocks

    ITimelock public timelock;
    IVotes public token;

    struct Proposal {
        uint id;
        address proposer;
        uint eta;
        uint startBlock;
        uint endBlock;
        uint forVotes;
        uint againstVotes;
        bool canceled;
        bool executed;
    }

    mapping (uint => Proposal) public proposals;
    uint public proposalCount;

    constructor(address _timelock, address _token) Ownable(msg.sender) {
        timelock = ITimelock(_timelock);
        token = IVotes(_token);
    }

    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
        require(token.getVotes(msg.sender) >= proposalThreshold, "Below threshold");
        
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.proposer = msg.sender;
        newProposal.startBlock = block.number;
        newProposal.endBlock = block.number + votingPeriod;

        return newProposal.id;
    }

    function castVote(uint proposalId, bool support) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.number <= proposal.endBlock, "Voting ended");
        uint256 weights = token.getVotes(msg.sender);

        if (support) {
            proposal.forVotes += weights;
        } else {
            proposal.againstVotes += weights;
        }
    }
}
