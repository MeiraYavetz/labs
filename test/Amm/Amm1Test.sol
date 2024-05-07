// SPDX-License-Identifier: MIT
// https://solidity-by-example.org/defi/staking-rewards/
// Code is a stripped down version of Synthetix
pragma solidity ^0.8.20;
import "../../src/AMM/Amm1.sol";
import "../../src/Staking/MyToken.sol";
import "../../src/Staking/MyToken2.sol";
import "forge-std/console.sol";

contract Amm1Test is Test{
    
    MyToken x ;
    MyToken2 y ;
    Amm1 amm1;
    
    function setUp() public{
        x = new MyToken();
        y = new MyToken2();
        amm1 = new Amm1(address(x),address(y)); 

        x.approve(address(amm1),100);
        x.mint(100);   
        y.approve(address(amm1),100);
        y.mint(100);
    }

    function testTradeXtoY() public {
        console.log("balance of test-amm1",x.balanceOf(address(this)));
        uint256 amountX = 20;
        uint amountY = amm1.tradeXToY(amountX);
        assertEq(amountY, 16666666666666666666);
    }
}
