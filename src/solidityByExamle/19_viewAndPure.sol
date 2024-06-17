// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ViewAndPure{
    uint256 public x =1;
    //view
    function addToX(uint256 y)public view returns(uint256) {
        return x + y;
    }
    //pure
    function add(uint256 j,uint256 z)public pure returns(uint256){
        return j + z;
    }
}