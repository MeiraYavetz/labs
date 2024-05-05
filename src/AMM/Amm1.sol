// SPDX-License-Identifier: MIT
// https://solidity-by-example.org/defi/staking-rewards/
// Code is a stripped down version of Synthetix

pragma solidity ^0.8.20;
import "../like/IERC20.sol";
import "forge-std/console.sol";
import "../audit/approve.sol";

contract Amm1{
    
    ERC20 x;
    ERC20 y;
    uint k;
    uint WAD;
    
    constructor(){
        x.approve(address(this),1000);
        x.mint(1000);
        y.approve(address(this),1000);
        y.mint(1000);
        k = x.balanceOf(address(this)) * y.balanceOf(address(this));
        WAD = 10**18;
    }

    function price() public pure returns(uint){
        return x > y ? (x * WAD / y) : (y * WAD / x);
    }
 
    function tradeXToY(uint amount) public returns(uint){
        require(amount > 0, "amount is illegal");
        x.transferFrom(address(msg.sender),address(this),amount);
        uint amountY = y.balanceOf(address(this)) * WAD / price();
        uint result = y.balanceOf(address(this)) - amountY;        
        require(result < y.balanceOf(address(this)), "There is no enough liquidity");
        y.burn(result);
        return result;
    }

    function tradeYToX(uint amount) public returns(uint){
        require(amount > 0, "amount is illegal");
        y.transferFrom(address(msg.sender),address(this),amount);
        uint amountX = x.balanceOf(address(this)) * WAD / price();
        uint result = x.balanceOf(address(this)) - amountX;
        require(result < x.balanceOf(address(this)), "There is no enough liquidity");
        x.burn(result);
        return result;
    }

    function addLiquidity(uint amountX, uint amountY) public {
        uint rate = amountX > amountY ? (amountX * WAD / amountY) : (amountY * WAD / amountX);
        require(rate == price(), "rate not equal");
        x.transferFrom(address(msg.sender),address(this),amountX);
        y.transferFrom(address(msg.sender),address(this),amountY);
        k = x.balanceOf(address(this)) * y.balanceOf(address(this));
    }
    function removeLiquidity(uint amountX, uint amountY) public {
        uint rate = amountX > amountY ? (amountX * WAD / amountY) : (amountY * WAD / amountX);
        require(rate == price(), "rate not equal");
        x.burn(amountX);
        y.burn(amountY);
        k = x.balanceOf(address(this)) * y.balanceOf(address(this));
    }
}