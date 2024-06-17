import "./IERC20.sol";

pragma solidity ^0.8.20;

interface IWETHGateway {
    function depositETH(address lendingPool, address onBehalfOf, uint16 referralCode) external payable;

    function withdrawETH(address lendingPool, uint256 amount, address onBehalfOf) external;
}
