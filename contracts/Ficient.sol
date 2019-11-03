pragma solidity^0.5.0;

import "./IArbRail.sol";
import "./SafeMath.sol";
import "./IFlashLoanReceiver.sol";
import "./LendingPoolAddressesProvider.sol";

contract Factory {
	/// Hardcode more addresses here
	address daiAddress = "0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359";
	event constructed(string created);

    constructor() internal {
		emit constructed("Fuck");
	}
	
	// Function to called by webjs
	function setCircuit(address[] calldata upgradeCircuit, uint256 amount) external returns (bool didSucceed) {
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
	
  event loanCalled(string called);

  constructor(address[] circuit, uint256 amount) internal {
	circuitToExecute = circuit;
  }

  function executeOperation(address _reserve, uint256 _amount, uint256 _fee) external returns (uint256 returnedAmount) {
    require(_amount <= getBalanceInternal(address(this), _reserve),
    "Invalid balance for the contract");

	// Execute trades
	emit eventCalled("Flash loan executed.");
	
	transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));
	return _amount.add(_fee);
  }

  function () payable external {
    revert();
  }
}
