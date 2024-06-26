//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./interfaces/AggregatorV3Interface.sol";

// import "./interfaces/ISwapRouter.sol";
// import "./math.sol";
// import "./ERC20Token.sol";

// interface ILendingPool {
//     function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;

//     function withdraw(address asset, uint256 amount, address to) external returns (uint256);
// }

// interface IWETHGateway {
//     function depositETH(address lendingPool, address onBehalfOf, uint16 referralCode) external payable;

//     function withdrawETH(address lendingPool, uint256 amount, address onBehalfOf) external;
// }

// interface IUniswapRouter is ISwapRouter {
//     function refundETH() external payable;
// }

// contract BondToken is Ownable {
//     using MathLib for uint256;

//     using SafeMath for uint256;

//     uint256 public totalBorrowed; // all user borrowed
//     uint256 public totalReserve; // all fees from borrowers and whats left from colletoral that swap to DAI (what bigger from the borrow)
//     uint256 public totalDeposit; // all money in the pool (DAI) (deposits and borrowed)
//     uint256 public maxLTV = 4; // 1 = 20%
//     uint256 public ethTreasury;
//     uint256 public totalCollateral; // all Collateral deposit
//     uint256 public baseRate = 20000000000000000;
//     uint256 public fixedAnnuBorrowRate = 300000000000000000;

//     ILendingPool public constant aave = ILendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);
//     IWETHGateway public constant wethGateway = IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70);

//     IERC20 public constant dai = IERC20(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
//     IERC20 public constant aDai = IERC20(0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8);
//     IERC20 public constant aWeth = IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347);

//     AggregatorV3Interface internal constant priceFeed =
//         AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);

//     IUniswapRouter public constant uniswapRouter = IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

//     IERC20 private constant weth = IERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);

//     mapping(address => uint256) private usersCollateral; // all Collateral deposit per user
//     mapping(address => uint256) private usersBorrowed; // all Borrowed users per user

//     ERC20Token public bDAI;

//     constructor() {
//         bDAI = ERC20Token("Bond DAI", "bDAI");
//     }

//     function deposit(uint256 _amount) external {
//         // deposit - depositBond
//         dai.transferFrom(msg.sender, address(this), _amount);
//         totalDeposit += _amount;
//         _sendDaiToAave(_amount); // to get fee from AAVE
//         uint256 bondsToMint = _amount.wDiv(getExchangeRate());
//         bDAI.mint(msg.sender, bondsToMint);
//     }

//     function withDraw(uint256 _amount) external {
//         // withDraw
//         require(_amount <= bDAI.balanceOf(msg.sender), "Not enough bonds!");
//         uint256 daiToReceive = _amount.mulExp(getExchangeRate());
//         totalDeposit -= daiToReceive;
//         bDAI.burn(_amount);
//         _withdrawDaiFromAave(daiToReceive);
//     }

//     function addCollateral() external payable {
//         require(msg.value != 0, "Cant send 0 ethers");
//         usersCollateral[msg.sender] += msg.value;
//         totalCollateral += msg.value;
//         _sendWethToAave(msg.value);
//     }

//     function removeCollateral(uint256 _amount) external {
//         uint256 wethPrice = uint256(_getLatestPrice());
//         uint256 collateral = usersCollateral[msg.sender];
//         require(collateral > 0, "Dont have any collateral");
//         uint256 borrowed = usersBorrowed[msg.sender];
//         uint256 amountLeft = collateral.mulExp(wethPrice).sub(borrowed);
//         uint256 amountToRemove = _amount.mulExp(wethPrice);
//         require(amountToRemove < amountLeft, "Not enough collateral to remove");
//         usersCollateral[msg.sender] -= _amount;
//         totalCollateral -= _amount;
//         _withdrawWethFromAave(_amount);
//         payable(address(this)).transfer(_amount);
//     }

//     function borrow(uint256 _amount) external {
//         require(_amount <= _borrowLimit(), "No collateral enough");
//         usersBorrowed[msg.sender] += _amount;
//         totalBorrowed += _amount;
//         _withdrawDaiFromAave(_amount);
//     }

//     function repay(uint256 _amount) external {
//         require(usersBorrowed[msg.sender] > 0, "Doesnt have a debt to pay");
//         dai.transferFrom(msg.sender, address(this), _amount);
//         (uint256 fee, uint256 paid) = calculateBorrowFee(_amount);
//         usersBorrowed[msg.sender] -= paid;
//         totalBorrowed -= paid;
//         totalReserve += fee;
//         _sendDaiToAave(_amount);
//     }

//     function calculateBorrowFee(uint256 _amount) public view returns (uint256, uint256) {
//         uint256 borrowRate = _borrowRate();
//         uint256 fee = _amount.mulExp(borrowRate);
//         uint256 paid = _amount.sub(fee);
//         return (fee, paid);
//     }

//     function liquidation(address _user) external onlyOwner {
//         uint256 wethPrice = uint256(_getLatestPrice());
//         uint256 collateral = usersCollateral[_user];
//         uint256 borrowed = usersBorrowed[_user];
//         uint256 collateralToUsd = wethPrice.mulExp(collateral);
//         if (borrowed > MathLib.percentage(collateralToUsd, maxLTV)) {
//             _withdrawWethFromAave(collateral);
//             uint256 amountDai = _convertEthToDai(collateral);
//             if (amountDai > borrowed) {
//                 uint256 extraAmount = amountDai.sub(borrowed);
//                 totalReserve += extraAmount;
//             }
//             _sendDaiToAave(amountDai);
//             usersBorrowed[_user] = 0;
//             usersCollateral[_user] = 0;
//             totalCollateral -= collateral;
//         }
//     }

//     function harvestRewards() external onlyOwner {
//         uint256 aWethBalance = aWeth.balanceOf(address(this));
//         if (aWethBalance > totalCollateral) {
//             uint256 rewards = aWethBalance.sub(totalCollateral);
//             _withdrawWethFromAave(rewards);
//             ethTreasury += rewards;
//         }
//     }

//     function convertTreasuryToReserve() external onlyOwner {
//         uint256 amountDai = _convertEthToDai(ethTreasury);
//         ethTreasury = 0;
//         totalReserve += amountDai;
//     }

//     function _borrowLimit() public view returns (uint256) {
//         uint256 amountLocked = usersCollateral[msg.sender];
//         require(amountLocked > 0, "No collateral found");
//         uint256 amountBorrowed = usersBorrowed[msg.sender];
//         uint256 wethPrice = uint256(_getLatestPrice());
//         uint256 amountLeft = amountLocked.mulExp(wethPrice).sub(amountBorrowed);
//         return amountLeft.percentage(maxLTV);
//     }

//     function _sendDaiToAave(uint256 _amount) internal {
//         dai.approve(address(aave), _amount);
//         aave.deposit(address(dai), _amount, address(this), 0);
//     }

//     function _withdrawDaiFromAave(uint256 _amount) internal {
//         aave.withdraw(address(dai), _amount, msg.sender);
//     }

//     function _sendWethToAave(uint256 _amount) internal {
//         wethGateway.depositETH{value: _amount}(address(aave), address(this), 0);
//     }

//     function _withdrawWethFromAave(uint256 _amount) internal {
//         aWeth.approve(address(wethGateway), _amount);
//         wethGateway.withdrawETH(address(aave), _amount, address(this));
//     }

//     function getCollateral() external view returns (uint256) {
//         return usersCollateral[msg.sender];
//     }

//     function getBorrowed() external view returns (uint256) {
//         return usersBorrowed[msg.sender];
//     }

//     function balance() public view returns (uint256) {
//         return aDai.balanceOf(address(this));
//     }

//     function _getLatestPrice() public view returns (int256) {
//         (, int256 price,,,) = priceFeed.latestRoundData();
//         return price * 10 ** 10;
//     }

//     function getExchangeRate() public view returns (uint256) {
//         if (bDAI.totalSupply() == 0) {
//             return 1000000000000000000; // WAD - 1e18 - 10**18
//         }
//         // uint256 cash = getCash(); // the cash in the pool (without totalBorrowed)
//         uint256 num = totalDeposit.add(totalReserve); // all the money in the contract (deposit, reserved)
//         return num.wDiv(bDAI.totalSupply()); // all money in the contract / bDAI (totalSupply)
//     }

//     function getCash() public view returns (uint256) {
//         return totalDeposit.sub(totalBorrowed); // totalDeposit - totalBorrowed
//     }

//     function _utilizationRatio() public view returns (uint256) {
//         return totalBorrowed.wDiv(totalDeposit);
//     }

//     function _interestMultiplier() public view returns (uint256) {
//         uint256 uRatio = _utilizationRatio();
//         uint256 num = fixedAnnuBorrowRate.sub(baseRate);
//         return num.wDiv(uRatio);
//     }

//     function _borrowRate() public view returns (uint256) {
//         uint256 uRatio = _utilizationRatio();
//         uint256 interestMul = _interestMultiplier();
//         uint256 product = uRatio.mulExp(interestMul);
//         return product.add(baseRate);
//     }

//     function _depositRate() public view returns (uint256) {
//         uint256 uRatio = _utilizationRatio();
//         uint256 bRate = _borrowRate();
//         return uRatio.mulExp(bRate);
//     }

//     function _convertEthToDai(uint256 _amount) internal returns (uint256) {
//         require(_amount > 0, "Must pass non 0 amount");

//         uint256 deadline = block.timestamp + 15; // using 'now' for convenience
//         address tokenIn = address(weth);
//         address tokenOut = address(dai);
//         uint24 fee = 3000;
//         address recipient = address(this);
//         uint256 amountIn = _amount;
//         uint256 amountOutMinimum = 1;
//         uint160 sqrtPriceLimitX96 = 0;

//         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams(
//             tokenIn, tokenOut, fee, recipient, deadline, amountIn, amountOutMinimum, sqrtPriceLimitX96
//         );

//         uint256 amountOut = uniswapRouter.exactInputSingle{value: _amount}(params);
//         uniswapRouter.refundETH();
//         return amountOut;
//     }

//     receive() external payable {}

//     fallback() external payable {}
// }
