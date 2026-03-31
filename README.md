# Governance Alpha Vault

A professional-grade, standard-compliant Governance system for high-value decentralized organizations. This repository implements the battle-tested "Alpha" logic used by major protocols like Compound and Uniswap, optimized into a single-directory flat structure.

## Core Components
* **Governor Alpha:** Handles the lifecycle of a proposal from submission to execution.
* **Voting Power:** Real-time snapshots of delegated voting weights.
* **Timelock:** Mandatory 2-day delay for any successful proposal before execution.
* **Quorum:** High-security threshold to prevent minority-led protocol changes.

## Governance Lifecycle
1. **Propose:** A holder with >1% of total supply submits a set of actions.
2. **Vote:** Holders cast "For", "Against", or "Abstain" votes.
3. **Queue:** If passed, the proposal enters the Timelock queue.
4. **Execute:** After 48 hours, the proposal is executed via the Timelock's authority.

## Setup
1. `npm install`
2. Deploy `GovToken.sol` and `Timelock.sol`.
3. Deploy `GovernorAlpha.sol` using the addresses from step 2.
