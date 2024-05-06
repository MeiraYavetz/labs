// SPDX-License-Identifier: MIT
// https://solidity-by-example.org/defi/staking-rewards/
// Code is a stripped down version of Synthetix
pragma solidity ^0.8.20;
import "../../src/AMM/Amm1.sol";
import "../../src/Staking/MyToken.sol";
import "../../src/Staking/MyToken2.sol";




contract Amm1Test is Test{
    
    MyToken x ;
    MyToken2 y ;
    Amm1 amm1;
    
    function setUp() public{
        x = new MyToken();
        y = new MyToken2();
        amm1 = new Amm1(address(x),address(y)); 
    }

    function testTradeXtoY() public {
        address user = vm.addr(123);
        vm.startPrank(user);  
        uint amountX = 20;      
        vm.deal(user, amountX);
        uint amountY = amm1.tradeXToY(amountX);
        assertEq(amountY, 16666666666666666666);
        vm.stopPrank();
    }

}
