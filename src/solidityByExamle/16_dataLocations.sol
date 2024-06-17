// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataLocations{
    
    struct MyStruct{
        uint256 foo;
    }
    mapping(uint256 => MyStruct)public myStructs;

    function f() public{
        //get 
        MyStruct storage myStorage = myStructs[1];
        //create in memory
        MyStruct memory myMemory = MyStruct(0);
    }
}