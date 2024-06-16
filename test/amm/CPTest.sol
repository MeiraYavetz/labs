// SPDX-License-Identifier: MIT
// https://solidity-by-example.org/defi/staking-rewards/
// Code is a stripped down version of Synthetix
pragma solidity ^0.8.20;
import "forge-std/console.sol";
import "forge-std/Test.sol";

import "../../src/Staking/MyToken.sol";
import "../../src/AMM/CP.sol";

contract CPTest is Test{

    MyERC20 token0;
    MyERC20 token1;
    CP cp;
    function setUp() public{
        token0 = new MyERC20(100);
        token1 = new MyERC20(100);
        cp = new CP(address(token0),address(token1));
        token0.approve(address(this),100);
        token0.approve(address(cp),100);
        token0.mint(address(cp),100);
        token1.mint(address(cp),100);

    }
    function testSwap()public{
        
        uint amountOut = cp.swap(address(token0),20);
        console.log(token0.balanceOf(address(token0)),"balance of token0");
        console.log(token1.balanceOf(address(token1)),"balance of token1");
        console.log(amountOut);
    }



}