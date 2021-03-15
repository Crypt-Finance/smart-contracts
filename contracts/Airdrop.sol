// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
/**
 *  Contract for administering the Airdrop of RIP.
 *  500,000 RIP will be made available via the Airdrop.
 */
contract Airdrop {
    // token addresses
    address public rip;
    address public owner;
    address public remainderDestination;

    // amount of RIP to transfer
    mapping (address => uint96) public withdrawAmount;

    uint public totalAllocated;

    bool public claimingAllowed;
    
    // Giving away 500,000 rip
    uint constant public TOTAL_AIRDROP_SUPPLY = 500_000e18;

    // Events
    event ClaimingAllowed();
    event ClaimingOver();
    event RipClaimed(address claimer, uint amount);

    /**
     * Initializes the contract. Sets token addresses, owner, and leftover token
     * destination. Claiming period is not enabled.
     *
     * @param rip_ the rip token contract address
     * @param owner_ the privileged contract owner
     * @param remainderDestination_ address to transfer remaining rip to when
     *     claiming ends. Should be community treasury.
     */
    constructor(address rip_,
                address owner_,
                address remainderDestination_) {
        rip = rip_;
        owner = owner_;
        remainderDestination = remainderDestination_;
        claimingAllowed = false;
        totalAllocated = 0;
    }

    /**
     * Changes the address that receives the remaining rip at the end of the
     * claiming period. Can only be set by the contract owner.
     *
     * @param remainderDestination_ address to transfer remaining rip to when
     *     claiming ends.
     */
    function setRemainderDestination(address remainderDestination_) external {
        require(msg.sender == owner, 'Airdrop::setRemainderDestination: unauthorized');
        remainderDestination = remainderDestination_;
    }

    /**
     * Changes the contract owner. Can only be set by the contract owner.
     *
     * @param owner_ new contract owner address
     */
    function setowner(address owner_) external {
        require(msg.sender == owner, 'Airdrop::setowner: unauthorized');
        owner = owner_;
    }

    /**
     * Enable the claiming period and allow user to claim rip. Before activation,
     * this contract must have a rip balance equal to the total airdrop rip
     * supply of 16.9 million rip. All claimable rip tokens must be whitelisted
     * before claiming is enabled. Only callable by the owner.
     */
    function allowClaiming() external {
        require(IRIP(rip).balanceOf(address(this)) >= TOTAL_AIRDROP_SUPPLY, 'Airdrop::allowClaiming: incorrect rip supply');
        require(msg.sender == owner, 'Airdrop::allowClaiming: unauthorized');
        claimingAllowed = true;
        emit ClaimingAllowed();
    }

    /**
     * End the claiming period. All unclaimed rip will be transferred to the address
     * specified by remainderDestination. Can only be called by the owner.
     */
    function endClaiming() external {
        require(msg.sender == owner, 'Airdrop::endClaiming: unauthorized');
        require(claimingAllowed, "Airdrop::endClaiming: Claiming not started");

        claimingAllowed = false;
        emit ClaimingOver();

        // Transfer remainder
        uint amount = IRIP(rip).balanceOf(address(this));
        require(IRIP(rip).transfer(remainderDestination, amount), 'Airdrop::endClaiming: Transfer failed');
    }

    /**
     * Withdraw your rip. In order to qualify for a withdrawl, the caller's address
     * must be whitelisted. All rip must be claimed at once. Only the full amount can be
     * claimed and only one claim is allowed per user.
     */
    function claim() external {
        // tradeoff: if you only transfer one but you held both, you can't claim
        require(claimingAllowed, 'Airdrop::claim: Claiming is not allowed');
        require(withdrawAmount[msg.sender] > 0, 'Airdrop::claim: No rip to claim');

        uint amountToClaim = withdrawAmount[msg.sender];
        withdrawAmount[msg.sender] = 0;

        emit RipClaimed(msg.sender, amountToClaim);

        require(IRIP(rip).transfer(msg.sender, amountToClaim), 'Airdrop::claim: Transfer failed');
    }

    /**
     * Whitelist an address to claim rip. Specify the amount of rip to be allocated.
     * That address will then be able to claim that amount of rip during the claiming
     * period. The transferrable amount of
     * rip must be nonzero. Total amount allocated must be less than or equal to the
     * total airdrop supply. Whitelisting must occur before the claiming period is
     * enabled. Addresses may only be added one time. Only called by the owner.
     *
     * @param addr address that may claim rip
     * @param ripOut the amount of rip that addr may withdraw
     */
    function whitelistAddress(address addr, uint96 ripOut) public {
        require(msg.sender == owner, 'Airdrop::whitelistAddress: unauthorized');
        require(!claimingAllowed, 'Airdrop::whitelistAddress: claiming in session');
        require(ripOut > 0, 'Airdrop::whitelistAddress: No rip to allocated');
        require(withdrawAmount[addr] == 0, 'Airdrop::whitelistAddress: address already added');

        withdrawAmount[addr] = ripOut;

        totalAllocated = totalAllocated + ripOut;
        require(totalAllocated <= TOTAL_AIRDROP_SUPPLY, 'Airdrop::whitelistAddress: Exceeds rip allocation');
    }

    /**
     * Whitelist multiple addresses in one call. Wrapper around whitelistAddress.
     * All parameters are arrays. Each array must be the same length. Each index
     * corresponds to one (address, rip) tuple. Only callable by the owner.
     */
    function whitelistAddresses(address[] memory addrs, uint96[] memory ripOuts) external {
        require(msg.sender == owner, 'Airdrop::whitelistAddresses: unauthorized');
        require(addrs.length == ripOuts.length,
                'Airdrop::whitelistAddresses: incorrect array length');
        for (uint i = 0; i < addrs.length; i++) {
            whitelistAddress(addrs[i], ripOuts[i]);
        }
    }
}

interface IRIP {
    function balanceOf(address account) external view returns (uint);
    function transfer(address dst, uint rawAmount) external returns (bool);
}
