// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//you need to guess 6 numbers
//if you succeed to guess all numbers so you will get money to your wallet

// import "../tokens/myToken2.sol";

// contract WinnerCoin {
//     address public owner;
//     MyToken public myCoin;
//     mapping(address => bool) public winners;
//     uint256 public numberWin;
//     uint256 public endDate;
//     uint public counter;
//     uint public price;
//     uint public priceToWinner;

//     constructor() {
//         myCoin = new MyToken();
//         owner = msg.sender;
//         endDate = block.timestamp;
//     }

//     modifier isOwner() {
//         require(msg.sender == owner, "You are'nt owner!");
//         _;
//     }

//     modifier timeIsNotFinished() {
//         require (block.timestamp <= endDate, "time is finished!");
//         _;
//     }

//     modifier timeIsFinished() {
//         require (block.timestamp > endDate, "time is'nt finished!");
//         _;
//     }

//     function guessNumber(uint256 _numbers, uint256 coins) external timeIsNotFinished(){
//         require(coins == price , "You paid less or more than the price");
//         myCoin.transferFrom(msg.sender, address(this), coins);
//         if (_numbers == numberWin) {
//             winners[msg.sender] = true;
//             counter += 1;
//         }
//     }

//     function setEndDate(uint256 duration) external isOwner timeIsNotFinished returns(bool){
//         endDate = block.timestamp + duration;
//         return true;
//     }

//      function setPrice(uint256 _price) external isOwner {
//         price = _price;
//     }

//     function randomNumbers() external isOwner {
//         numberWin = 123456;
//     }

//     function rewardToWinners() external isOwner timeIsFinished {
//         uint p = priceToWinner / counter;
//         while (counter >= 0) {
//             // address user = winners[msg.sender];
//             address user = msg.sender;
//             myCoin.transfer(user, p);
//         }

//     }
// }
