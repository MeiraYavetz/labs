// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12 <0.9.0;
import "forge-std/console.sol";
import "../audit/approve.sol";

contract Staking is ERC20 {

    mapping(address=>mapping(uint256=>uint256)) public database;
    uint256 date;
    uint256 poolBalance;
    uint256 poolsRich;
    uint256 percent;
    address owner;
    
    constructor(){
        date = 0;
        poolBalance = 0;
        poolsRich = 1000000;
        percent = 1 / 10;
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender);
    }

    receive() external payable {}

    function deposit() public{}

    function withdraw(uint256 wad) external{
        if(calculateDays()!= 0){

        }
    }

    function calculateDays()public returns ( uint256){
        for(uint256 i = 0; i<database[msg.sender].length(); i++)
        {
            database[msg.sender][];
            if(date - 7 >= i)
            {
                
            }
            
        }
    }
    function calculateSum(uint256 _date) public returns (uint256){
        uint256 amount = database[msg.sender][_date];
        uint256 rate = amount / poolBalance;
        return rate * (percent * poolsRich);
    }

}