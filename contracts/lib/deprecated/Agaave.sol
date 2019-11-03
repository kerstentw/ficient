pragma solidity^0.5.0;

/*
  @dev: This is the interface for Aave aTokens
*/

contract ATokenInterface {
  function name () external view returns ( string );
  function approve ( address spender, uint256 value ) external returns ( bool );
  function totalSupply () external view returns ( uint256 );
  function transferFrom ( address sender, address recipient, uint256 amount ) external returns ( bool );
  function decimals () external view returns ( uint8 );
  function increaseAllowance ( address spender, uint256 addedValue ) external returns ( bool );
  function initialExchangeRate () external view returns ( uint256 );
  function balanceOf ( address account ) external view returns ( uint256 );
  function underlyingAssetAddress () external view returns ( address );
  function symbol () external view returns ( string );
  function underlyingAssetDecimals () external view returns ( uint256 );
  function decreaseAllowance ( address spender, uint256 subtractedValue ) external returns ( bool );
  function transfer ( address recipient, uint256 amount ) external returns ( bool );
  function allowance ( address owner, address spender ) external view returns ( uint256 );
  function redeem ( uint256 _amount ) external;
  function mintOnDeposit ( address _account, uint256 _underlyingAmount ) external;
  function burnOnLiquidation ( address account, uint256 value ) external;
  function transferOnLiquidation ( address from, address to, uint256 value ) external;
  function getExchangeRate () external view returns ( uint256 );
  function balanceOfUnderlying ( address _user ) external view returns ( uint256 );
  function aTokenAmountToUnderlyingAmount ( uint256 _amount ) external view returns ( uint256 );
  function isTransferAllowed ( address _from, uint256 _amount ) external view returns ( bool );
  function underlyingAmountToATokenAmount ( uint256 _amount ) external view returns ( uint256 );
}

/*
  @dev: This is the interface for the Aave LendingPool
*/

contract LendingPoolInterface {
  function addressesProvider () external view returns ( address );
  function deposit ( address _reserve, uint256 _amount, uint16 _referralCode ) external payable;
  function redeemUnderlying ( address _reserve, address _user, uint256 _amount ) external;
  function borrow ( address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode ) external;
  function repay ( address _reserve, uint256 _amount, address _onBehalfOf ) external payable;
  function swapBorrowRateMode ( address _reserve ) external;
  function rebalanceFixedBorrowRate ( address _reserve, address _user ) external;
  function setUserUseReserveAsCollateral ( address _reserve, bool _useAsCollateral ) external;
  function liquidationCall ( address _collateral, address _reserve, address _user, uint256 _purchaseAmount, bool _receiveAToken ) external payable;
  function flashLoan ( address _receiver, address _reserve, uint256 _amount ) external;
  function getReserveConfigurationData ( address _reserve ) external view returns ( uint256 ltv, uint256 liquidationThreshold, uint256 liquidationDiscount, address interestRateStrategyAddress, bool usageAsCollateralEnabled, bool borrowingEnabled, bool fixedBorrowRateEnabled, bool isActive );
  function getReserveData ( address _reserve ) external view returns ( uint256 totalLiquidity, uint256 availableLiquidity, uint256 totalBorrowsFixed, uint256 totalBorrowsVariable, uint256 liquidityRate, uint256 variableBorrowRate, uint256 fixedBorrowRate, uint256 averageFixedBorrowRate, uint256 utilizationRate, uint256 liquidityIndex, uint256 variableBorrowIndex, address aTokenAddress, uint40 lastUpdateTimestamp );
  function getUserAccountData ( address _user ) external view returns ( uint256 totalLiquidityETH, uint256 totalCollateralETH, uint256 totalBorrowsETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor );
  function getUserReserveData ( address _reserve, address _user ) external view returns ( uint256 currentATokenBalance, uint256 currentUnderlyingBalance, uint256 currentBorrowBalance, uint256 principalBorrowBalance, uint256 borrowRateMode, uint256 borrowRate, uint256 liquidityRate, uint256 originationFee, uint256 variableBorrowIndex, uint256 lastUpdateTimestamp, bool usageAsCollateralEnabled );
  function getReserves () external view returns ( address[] );
}

contract Agaave {

  LendingPoolInterface LendingPool = 	LendingPoolInterface(0xB36017F5aafDE1a9462959f0e53866433D373404);


  constructor () external {

  }


  function () payable external {

  }

}
