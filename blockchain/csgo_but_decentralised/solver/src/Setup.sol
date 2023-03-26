pragma solidity ^0.8.13;

import "./Chal.sol";

contract Setup {
    Chal public immutable TARGET;
    constructor() payable {
        TARGET = new Chal();
    }

    function isSolved() public view returns (bool) {
        for (uint i = 0; i < 20; i++) {
            Enemy enemy = TARGET.enemies(i);
            if (!enemy.isDead()) {
                return false;
            }
        }
        return true;
    }
}