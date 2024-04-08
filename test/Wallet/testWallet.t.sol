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
        payable(address(W)).transfer(1000); // move 1000 to the contract
    }
    function testReceive() public {
        randomAddress = vm.addr(1234); // create random address
        vm.startPrank(randomAddress); // send from random address
        uint256 amount = 1000;
        vmaddress.deal(randomAddress, amount); // put money in this wallet
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
        payable(address(W)).transfer(amount); // move 1000 to the contract
        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        assertEq(finalBalance, initialBalance + amount);
        vm.stopPrank();
    }
    function testAllowedWithdraw() external {

        uint256 withdrawAmount = 50;
        address userAddress = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d; // address of allowed user
        vm.startPrank(userAddress); // send from random address
        
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
       
        
        console.log(initialBalance);
        console.log(withdrawAmount);
        //vm.expectRevert();

        W.withdraw(withdrawAmount);

        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        console.log(finalBalance);
        
        assertEq(finalBalance, initialBalance - withdrawAmount);
        
        vm.stopPrank();
    }
    
    function testNotAllowedWithdraw() external {

        uint256 withdrawAmount = 50; 
        address userAddress = vm.addr(12); // address of not allowed user
        vm.startPrank(userAddress); // send from random address
        
        uint256 initialBalance = address(W).balance; // the balance in the begining (before transfer)
        console.log(initialBalance);
        console.log(withdrawAmount);
        vm.expectRevert();
        W.withdraw(withdrawAmount);
        uint256 finalBalance = address(W).balance; // the balance in the final (aftere transfer)
        console.log(finalBalance);

        //assertEq(finalBalance, initialBalance - withdrawAmount);
        
        vm.stopPrank();
    }
    function testUpdate() public{
        address oldGabai = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d;
        address newGabai = 0x57C91e4803E3bF32c42a0e8579aCaa5f3762af71;

        address userAddress = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496; // address of allowed user
        
        //address userAddress = vm.addr(1); // address of not allowed user
        vm.startPrank(userAddress); // send from random address
        
        W.update(oldGabai, newGabai);
        
        vm.expectRevert();
        W.update(oldGabai, newGabai);
        
        assertEq(W.gabaim(newGabai),1);
        assertEq(W.gabaim(oldGabai),0);
        assertEq(W.owner(),0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496); 
        vm.stopPrank();

    }
    function testGetBalance() public{
       
        // assertEq(wallet.getBalance(), 50 , "not equals"); 
        assertEq(W.getBalance(), address(W).balance , "not equals");
    }

}
