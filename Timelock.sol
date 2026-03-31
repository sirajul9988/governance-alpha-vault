// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Timelock {
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);

    uint public constant GRACE_PERIOD = 14 days;
    uint public constant MINIMUM_DELAY = 2 days;
    uint public constant MAXIMUM_DELAY = 30 days;

    address public admin;
    uint public delay;

    mapping (bytes32 => bool) public queuedTransactions;

    constructor(address admin_, uint delay_) {
        require(delay_ >= MINIMUM_DELAY, "Delay < min");
        require(delay_ <= MAXIMUM_DELAY, "Delay > max");
        admin = admin_;
        delay = delay_;
    }

    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) public returns (bytes32) {
        require(msg.sender == admin, "Only admin");
        require(eta >= block.timestamp + delay, "ETA < delay");

        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        queuedTransactions[txHash] = true;

        emit QueueTransaction(txHash, target, value, signature, data, eta);
        return txHash;
    }
}
