// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/Wallet/Wallet.sol";

contract WalletTest is Test{
    wallet public w;
    function  setUp() public{
        w = new wallet();
    }

    function testOwnerWithdraw() external{
        uint256 initBalance = w.getBalance();
        uint256 withdrawAmount = 5;
        w.withdraw(withdrawAmount);
        uint256 finalBalance = w.getBalance();

        assertEq(initBalance + withdrawAmount, finalBalance,"it is not work!!!");
    }
    function testGabaimWithdraw() external{
        uint256 initBalance = w.getBalance();
        uint256 withdrawAmount = 5;
        forge.sender = address(0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d);
        w.withdraw(withdrawAmount);
        uint256 finalBalance = w.getBalance();

        assertEq(initBalance + withdrawAmount, finalBalance,"it is not work!!!");
    }function testUpdate() public{
        address oldGabai = "0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d";
        address newGabai = "0x7c0FA5571c4A1A67FD21Ed9209674868cC8dc86b";
        w.update(oldGabai,newGabai);
        assertEq(w.gabaim[newGabai],1);
        assertEq(w.gabaim[oldGabai],0);
    }

    function testGetBalance() public{
        assertEq(w.getBalance(),0.009999999999999999,"not equals");
    }

}