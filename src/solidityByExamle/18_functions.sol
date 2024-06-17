// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Functions{
    function way1ToReturn() public pure returns(uint256,bool,uint256){
        return (1,true,9);
    }
    function way2ToReturn() public pure returns(uint256 x, bool flag, uint256 y){
        x = 3;
        flag = false;
        y = 6;
    }
}