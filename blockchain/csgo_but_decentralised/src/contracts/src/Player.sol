// SPDX-License-Identifier: UNLICENSED
//
// Challenge author: Shanyu Thibaut JUNEJA (sin), UMass Cyber-Security Club.
// Challenge prepared for UMass CTF 2023
pragma solidity ^0.8.13;

import "./openzeppelin/Ownable.sol";

interface Player {
    function handleRecoil() external;
}