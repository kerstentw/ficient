pragma solidity^0.5.0;

import "ArbRail.sol";
import "./lib/SafeMath.sol";
import "lib/flashloan/base/FlashLoanReceiverBase.sol";
import "lib/flashloan/interfaces/IFlashLoanReceiver.sol";

/*
  @dev: This is the interface for the Aave LendingPool
*/

interface ILendingPool {
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

contract Ficient is FlashLoanReceiverBase {
  //using SafeMath for uint256;

  unint256 feePercent;
  address lending_pool_addr = 0xB36017F5aafDE1a9462959f0e53866433D373404;
  ILendingPool LendingPool = ILendingPool(lending_pool_addr);

  // []
  mapping (address => address) mounted_rails;

  constructor (address _iflash_contract) public external {

  }

  function MountRail(address _token_addr, address _rail_addr) {
    mounted_rails[_token_addr] = _rail_addr;
  }


  function executeOperation(address _reserve, uint256 _amount, uint256 _fee) external returns (uint256 returnedAmount) {

    require(_amount <= getBalanceInternal(address(this), _reserve),
    "Invalid balance for the contract");

    /*
      This is where the Rails Logic goes

      IRails new Rails(mounted_rails[reserve])
    */

    transferFundsBackToPoolInternal();

    return _remainging
  }



  function () payable external {
    revert();
  }
}
