// SPDX-License-Identifier: UNLICENSED

// Challenge author: Shanyu Thibaut JUNEJA (sin), UMass Cyber-Security Club.
// Challenge prepared for UMass CTF 2023
pragma solidity ^0.8.13;

import "./Enemy.sol";
import "./Player.sol";

contract Chal {
    Enemy[20] public enemies;

    uint private players;

    mapping (address => bool) guns;
    mapping (address => uint) bullets;

    constructor() {
        for (uint i = 0; i < 20; i++) {
            enemies[i] = new Enemy();
        }
    }

    function grabGun() public {
        require(guns[msg.sender] == false, "You have already equiped your gun");
        require(players <= 20, "The game can only have 20 players on each team!");

        guns[msg.sender] = true;
        bullets[msg.sender] = 1;
        players += 1;
    }

    function shootEnemies() public {
        require(guns[msg.sender] == true, "You have to pick up a gun");
        require(bullets[msg.sender] > 0, "You have ran out of bullets");

        for (uint i = 0; i < 20; i++) {
            if (enemies[i].isDead())
                continue;
            
            enemies[i].shoot();
            break;
        }

        require (bullets[msg.sender] - 1 < bullets[msg.sender], "Nice integer underflow");
        Player player = Player(msg.sender);
        player.handleRecoil();
        
        bullets[msg.sender] = 0;
    }
}
