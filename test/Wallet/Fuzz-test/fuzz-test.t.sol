// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../../src/Wallet/Wallet.sol";

contract FuzzTest is Test{

    Wallet public W;
    function  setUp() public{
        W = new Wallet();
        payable(address(W)).transfer(1000); // move 1000 to the contract
    }
       function testReceive(uint96 amount) public {
        console.log(amount);
        address randomAddress = vm.addr(1234); // create random address
        vm.startPrank(randomAddress); // send from random address
        //uint256 amount = 1000;
        vm.deal(randomAddress, amount); // put money in this wallet
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
        payable(address(W)).transfer(amount); // move 1000 to the contract
        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        assertEq(finalBalance, initialBalance + amount);
        vm.stopPrank();
    }
    function testAllowedWithdraw(uint8 amount) external {

        //uint256 withdrawAmount = 50;
        address userAddress = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d; // address of allowed user
        vm.startPrank(userAddress); // send from random address
        
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
       
        
        console.log(initialBalance);
        console.log(amount);
        //vm.expectRevert();

        W.withdraw(amount);

        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        console.log(finalBalance);
        
        assertEq(finalBalance, initialBalance - amount);
        
        vm.stopPrank();
    }
  

}
