// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;
import "forge-std/console.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "../../src/Staking/master-chef-staking.sol";
import "../../src/audit/approve.sol";
import "../../src/Staking/MyToken2.sol";
contract MasterChefStakingTest is Test{
        StakingRewards public stakingRewards;
        MyToken2 public stakingToken;
        MyToken2 public rewardsToken;
        address user1 = vm.addr(1); 

    function setUp() public{
        stakingToken = new MyToken2();
        rewardsToken = new MyToken2();
        stakingRewards = new StakingRewards(address(stakingToken),address(rewardsToken));

        stakingRewards.setRewardsDuration(7 days);
        rewardsToken.approve(address(this),1000);
        rewardsToken.mint(1000);
        rewardsToken.transferFrom(address(this), address(stakingRewards), 1000);
        stakingToken.approve(address(this),200);
        stakingToken.mint(200);  
        stakingToken.transferFrom(address(this), user1, 100);
    }

    function testWithdraw1() public{
        console.log(stakingToken.balanceOf(user1), " balance of user1");
        console.log( user1," address of user1");
        vm.startPrank(user1);
        vm.warp(block.timestamp + 2);

        uint256 amount = 100;

        stakingRewards.stake(100);
        console.log(stakingToken.balanceOf(user1), "stakingToken");
        stakingRewards.withdraw(100);
        console.log(stakingToken.balanceOf(user1), "stakingToken");

        vm.stopPrank();
    }
}