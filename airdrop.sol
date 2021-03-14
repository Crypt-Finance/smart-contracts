// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 *  Contract for administering the Airdrop of DEATH to CAKE holders.
 *  500,000 DEATH will be made available in the airdrop. After the
 *  Airdrop period is over, all unclaimed DEATH will be transferred to the
 *  community treasury.
 */
contract Airdrop {
    // token addresses
    address public death;
    address public bnb;
    address public cake;

    address public owner;
    address public remainderDestination;

    // amount of DEATH to transfer
    mapping (address => uint96) public withdrawAmount;

    uint public totalAllocated;

    bool public claimingAllowed;
    
    // Giving away 500,000 DEATH
    uint constant public TOTAL_AIRDROP_SUPPLY = 500_000e18;

    // Events
    event ClaimingAllowed();
    event ClaimingOver();
    event DeathClaimed(address claimer, uint amount);

    /**
     * Initializes the contract. Sets token addresses, owner, and leftover token
     * destination. Claiming period is not enabled.
     *
     * @param death_ the DEATH token contract address
     * @param bnb_ the BNB token contract address
     * @param cake_ the CAKE token contract address
     * @param owner_ the privileged contract owner
     * @param remainderDestination_ address to transfer remaining DEATH to when
     *     claiming ends. Should be community treasury.
     */
    constructor(address death_,
                address bnb_,
                address cake_,
                address owner_,
                address remainderDestination_) {
        death = death_;
        bnb = bnb_;
        cake = cake_;
        owner = owner_;
        remainderDestination = remainderDestination_;
        claimingAllowed = false;
        totalAllocated = 0;
    }

    /**
     * Changes the address that receives the remaining DEATH at the end of the
     * claiming period. Can only be set by the contract owner.
     *
     * @param remainderDestination_ address to transfer remaining DEATH to when
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
     * Enable the claiming period and allow user to claim DEATH. Before activation,
     * this contract must have a DEATH balance equal to the total airdrop DEATH
     * supply of 16.9 million DEATH. All claimable DEATH tokens must be whitelisted
     * before claiming is enabled. Only callable by the owner.
     */
    function allowClaiming() external {
        require(IDEATH(death).balanceOf(address(this)) >= TOTAL_AIRDROP_SUPPLY, 'Airdrop::allowClaiming: incorrect DEATH supply');
        require(msg.sender == owner, 'Airdrop::allowClaiming: unauthorized');
        claimingAllowed = true;
        emit ClaimingAllowed();
    }

    /**
     * End the claiming period. All unclaimed DEATH will be transferred to the address
     * specified by remainderDestination. Can only be called by the owner.
     */
    function endClaiming() external {
        require(msg.sender == owner, 'Airdrop::endClaiming: unauthorized');
        require(claimingAllowed, "Airdrop::endClaiming: Claiming not started");

        claimingAllowed = false;
        emit ClaimingOver();

        // Transfer remainder
        uint amount = IDEATH(death).balanceOf(address(this));
        require(IDEATH(death).transfer(remainderDestination, amount), 'Airdrop::endClaiming: Transfer failed');
    }

    /**
     * Withdraw your DEATH. In order to qualify for a withdrawl, the caller's address
     * must be whitelisted. In addition, the calling address must have one whole BNB
     * or CAKE token. All DEATH must be claimed at once. Only the full amount can be
     * claimed and only one claim is allowed per user.
     */
    function claim() external {
        // tradeoff: if you only transfer one but you held both, you can't claim
        require(claimingAllowed, 'Airdrop::claim: Claiming is not allowed');
        require(withdrawAmount[msg.sender] > 0, 'Airdrop::claim: No DEATH to claim');

        uint oneToken = 1e18;
        require(IBnb(bnb).balanceOf(msg.sender) >= oneToken || ICake(cake).balanceOf(msg.sender) >= oneToken,
            'Airdrop::claim: Insufficient BNB or CAKE balance');

        uint amountToClaim = withdrawAmount[msg.sender];
        withdrawAmount[msg.sender] = 0;

        emit DeathClaimed(msg.sender, amountToClaim);

        require(IDEATH(death).transfer(msg.sender, amountToClaim), 'Airdrop::claim: Transfer failed');
    }

    /**
     * Whitelist an address to claim DEATH. Specify the amount of DEATH to be allocated.
     * That address will then be able to claim that amount of DEATH during the claiming
     * period if it has sufficient BNB and CAKE balance. The transferrable amount of
     * DEATH must be nonzero. Total amount allocated must be less than or equal to the
     * total airdrop supply. Whitelisting must occur before the claiming period is
     * enabled. Addresses may only be added one time. Only called by the owner.
     *
     * @param addr address that may claim DEATH
     * @param deathOut the amount of DEATH that addr may withdraw
     */
    function whitelistAddress(address addr, uint96 deathOut) public {
        require(msg.sender == owner, 'Airdrop::whitelistAddress: unauthorized');
        require(!claimingAllowed, 'Airdrop::whitelistAddress: claiming in session');
        require(deathOut > 0, 'Airdrop::whitelistAddress: No DEATH to allocated');
        require(withdrawAmount[addr] == 0, 'Airdrop::whitelistAddress: address already added');

        withdrawAmount[addr] = deathOut;

        totalAllocated = totalAllocated + deathOut;
        require(totalAllocated <= TOTAL_AIRDROP_SUPPLY, 'Airdrop::whitelistAddress: Exceeds DEATH allocation');
    }

    /**
     * Whitelist multiple addresses in one call. Wrapper around whitelistAddress.
     * All parameters are arrays. Each array must be the same length. Each index
     * corresponds to one (address, death) tuple. Only callable by the owner.
     */
    function whitelistAddresses(address[] memory addrs, uint96[] memory deathOuts) external {
        require(msg.sender == owner, 'Airdrop::whitelistAddresses: unauthorized');
        require(addrs.length == deathOuts.length,
                'Airdrop::whitelistAddresses: incorrect array length');
        for (uint i = 0; i < addrs.length; i++) {
            whitelistAddress(addrs[i], deathOuts[i]);
        }
    }
}

interface IDEATH {
    function balanceOf(address account) external view returns (uint);
    function transfer(address dst, uint rawAmount) external returns (bool);
}

interface IBnb {
    function balanceOf(address account) external view returns (uint);
}

interface ICake {
    function balanceOf(address account) external view returns (uint);
}