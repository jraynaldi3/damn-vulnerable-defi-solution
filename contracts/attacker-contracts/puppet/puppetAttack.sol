//SPDX-License-Identifier: NOLICENSE

pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
interface IUniswapV1Exchange {
    function ethToTokenSwapInput(uint ,uint ) external payable returns(uint);
    function tokenToEthSwapInput(uint ,uint ,uint) external returns(uint);
}



contract PuppetAttack {
    address target;
    address pool;
    IUniswapV1Exchange exchange;
    IERC20 token;

    constructor(
        address _target,
        address _pool,
        address _exchange,
        address _token
    ) {
        target = _target;
        pool = _pool;
        exchange = IUniswapV1Exchange(_exchange);
        token = IERC20(_token);
    }

    function drainExchange() external {
        while (address(exchange).balance > 100) {

        }
    }
}