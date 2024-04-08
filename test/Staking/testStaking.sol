// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/Staking/Staking.sol";

contract StakingTest is Test{

    Staking public staking;
    function setUp() public{
        staking = new Staking();

    }
    function testDeposit() public{
        address randomAddress = vm.addr(1234); // create random address
        vm.startPrank(randomAddress); // send from random address
        uint256 amount = 1000;
        vmaddress.deal(randomAddress, amount); // put money in this wallet
        uint256 initialPoolBalance = staking.poolBalance;
        console.log(initialPoolBalance);
        staking.deposit();
        uint256 finalPoolBalance = staking.poolBalance;
        console.log(finalPoolBalance);
        assertEq(finalPoolBalance, initialPoolBalance + amount);

    }
    function testWithdraw() public{

    }
}