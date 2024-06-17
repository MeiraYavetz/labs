// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.24 and less than 0.9.0
pragma solidity ^0.8.18;



contract EtherUnits{
    uint256 public oneWei = 1 wei;
    bool public isWei = (oneWei == 1);

    uint256 public oneGWei = 1 gwei;
    bool public isGWei = (oneGWei == 1e9);

    uint256 public oneEther = 1 ether;
    bool public isEther = (oneEther == 1e18); 
}