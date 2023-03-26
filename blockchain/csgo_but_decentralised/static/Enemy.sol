// SPDX-License-Identifier: UNLICENSED
//
// Challenge author: Shanyu Thibaut JUNEJA (sin), UMass Cyber-Security Club.
// Challenge prepared for UMass CTF 2023
pragma solidity ^0.8.13;

import "./openzeppelin/Ownable.sol";

contract Enemy is Ownable {
    uint public health = 20;

    function shoot() public onlyOwner {
        require (health > 0, "Trying to kill a dead entity");
        health = health - 1;
    }

    function isDead() public view returns (bool) {
        return health == 0;
    }
}
