pragma solidity^0.5.0;

import "ArbRailInterface.sol";
import "./IUniswapExchange.sol";

contract UniswapArbRail is ArbRailInterface {
  IUniswapFactory uniswapFactory = IUniswapFactory;

  // ERC20 => Uniswap => ERC20
  function swapTokenOnUniswap(ERC20 sellToken, uint sellTokenAmount, ERC20 buyToken) internal returns (uint) {
    uint256 minTokensBought = 1;
    uint256 minEtherBought = 1;
    address exchangeAddress = uniswapFactory.getExchange(address(sellToken));
    IUniswapExchange exchange = IUniswapExchange(exchangeAddress);
    sellToken.approve(address(exchange), sellTokenAmount);
    uint256 buyTokenAmount = exchange.tokenToTokenSwapInput(sellTokenAmount, minTokensBought, minEtherBought, block.timestamp, address(buyToken));
    return buyTokenAmount;
  }

  // ERC20 => Uniswap => ETH
  function __swapTokenToEtherOnUniswap(ERC20 sellToken, uint sellTokenAmount) internal returns (uint) {
    uint256 minTokensBought = 1;
    address exchangeAddress = uniswapFactory.getExchange(address(sellToken));
    IUniswapExchange exchange = IUniswapExchange(exchangeAddress);
    sellToken.approve(address(exchange), sellTokenAmount);
    uint256 etherAmount = exchange.tokenToEthSwapInput(sellTokenAmount, minTokensBought, block.timestamp);
    return etherAmount;
  }

  // ETH => Uniswap => ERC20
  function __swapEtherToTokenOnUniswap(ERC20 buyToken, uint sellEtherAmount) internal returns (uint) {
    uint256 minBuyAmount = 1;
    address exchangeAddress = uniswapFactory.getExchange(address(buyToken));
    IUniswapExchange exchange = IUniswapExchange(exchangeAddress);
    uint256 buyTokenAmount = exchange.ethToTokenSwapInput.value(sellEtherAmount)(minBuyAmount, block.timestamp);
    return buyTokenAmount;
  }
}
