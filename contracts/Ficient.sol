pragma solidity^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IArbRail.sol";
import "./SafeMath.sol";
import "./IFlashLoanReceiver.sol";
import "./LendingPoolAddressesProvider.sol";

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
  function getReserves () external view;
}

contract Factory {
	/// Hardcode more addresses here
	address daiAddress = 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD;
	event lendingPoolCalled(string eventCalled);
	
	// Function to called by webjs
	function setCircuit(uint256 amount) external returns (bool didSucceed) {
		// Call flash loan, uses dai as base lending address provider
		LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(0x9C6C63aA0cD4557d7aE6D9306C06C093A2e35408);
		ILendingPool lendingPool = ILendingPool(provider.getLendingPool());

		// Create child contract
		Ficient loanContract = new Ficient(amount);
		address ficientAddress = address(loanContract);

		/// flashLoan method call 
		lendingPool.flashLoan(ficientAddress, daiAddress, amount);
		emit lendingPoolCalled("Lending pool called");
		return true;
	}
}

contract Ficient is IFlashLoanReceiver {
  using SafeMath for uint256;
  uint256 feePercent;
  address[] circuitToExecute;
  event loanCalled(string called);

  constructor(uint256 amount) public {
	feePercent = amount;
  }

  function executeOperation(address _reserve, uint256 _amount, uint256 _fee) external returns (uint256 returnedAmount) {
	// Execute trades
	emit loanCalled("Flash loan executed.");
	
	// Transfer reserve (aDai), recipient is lending pool core.
 	IERC20(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD).transfer(0xAf4Ef1a755F05DD9D68E9e53F111eb63b05fB1FD, _amount.add(_fee));
	return _amount.add(_fee);
  }
}
