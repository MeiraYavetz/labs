pragma solidity ^0.8.20;

import "./ISwapRouter.sol";

interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}
