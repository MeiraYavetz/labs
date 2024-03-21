// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/Wallet/Wallet.sol";

contract WalletTest is Test{

    Wallet public W;
    function  setUp() public{
        W = new Wallet();
    }
       function testReceive() public {
        address randomAddress = vm.addr(1234); // create random address
        vm.startPrank(randomAddress); // send from random address
        uint256 amount = 1000;
        vm.deal(randomAddress, amount); // put money in this wallet
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
        payable(address(W)).transfer(1000); // move 50 to the contract
        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        assertEq(finalBalance, initialBalance + amount);
        vm.stopPrank();
    }
 function testAllowedWithdraw() external {

        uint256 withdrawAmount = 50;
        address userAddress = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d; // address of allowed user
        //address userAddress = vm.addr(12); // address of not allowed user
        vm.startPrank(userAddress); // send from random address
        
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
        vm.expectRevert();
        W.withdraw(withdrawAmount);
        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        //assertEq(finalBalance, initialBalance - withdrawAmount);
        
        vm.stopPrank();
    }
    
    function testUpdate() public{
        address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        address newGabai = 0x7c0FA5571c4A1A67FD21Ed9209674868cC8dc86b;

        address userAddress = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d; // address of allowed user
        //address userAddress = vm.addr(1); // address of not allowed user
        vm.startPrank(userAddress); // send from random address
        vm.expectRevert();
        W.update(oldGabai, newGabai);
        
       
        
        //assertEq(W.gabaim(newGabai),1);
        //assertEq(W.gabaim(oldGabai),0);
        vm.stopPrank();
        //assertEq(W.owner(),0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d); 
    }
    function testGetBalance() public{
       
        // assertEq(wallet.getBalance(), 50 , "not equals"); 
        assertEq(W.getBalance(), address(W).balance , "not equals");
    }

}
