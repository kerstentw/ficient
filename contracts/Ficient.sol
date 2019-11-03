pragma solidity^0.5.0;

import "./IArbRail.sol";
import "./SafeMath.sol";
import "./flashloan/base/FlashLoanReceiverBase.sol";
import "./flashloan/interfaces/IFlashLoanReceiver.sol";

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

contract Factory {
	/// Hardcode more addresses here
	address daiAddress = "0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359";
	event constructed(string created);

    constructor() {
		emit constructed("Fuck");
	}
	
	// Function to called by webjs
	function setCircuit(address[] upgradeCircuit, uint256, amount) external returns (bool didSucceed) {
		// Call flash loan, uses dai as base lending address provider
		LendingPoolAddressesProvider provider = LendingPoolAddressesProvider("0x8Ac14CE57A87A07A2F13c1797EfEEE8C0F8F571A");
		LendingPool lendingPool = LendingPool(provider.getLendingPool());

		// Create child contract
		Ficient loanContract = new Ficient(upgradeCircuit);
		address ficientAddress = address(loanContract);

		/// flashLoan method call 
		lendingPool.flashLoan(ficientAddress, daiAddress, amount);
		return true;
	}
}

contract Ficient is FlashLoanReceiverBase {
  unint256 feePercent;
  address[] circuitToExecute;

  constructor(address[] circuit, uint256 amount) {
	circuitToExecute = circuit;
  }

  function executeOperation(address _reserve, uint256 _amount, uint256 _fee) external returns (uint256 returnedAmount) {
    require(_amount <= getBalanceInternal(address(this), _reserve),
    "Invalid balance for the contract");

	// Execute trades
	
	
	transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));
	return _amount.add(_fee);
  }

  function () payable external {
    revert();
  }
}
