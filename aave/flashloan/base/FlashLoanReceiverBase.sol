pragma solidity ^0.5.0;

import "../interfaces/IFlashLoanReceiver.sol";
import "../../interfaces/ilendingpooladdressesprovider.sol";
import "../../interfaces/inetworkmetadataprovider.sol";

contract FlashLoanReceiverBase is IFlashLoanReceiver {
    ILendingPoolAddressesProvider addressesProvider;

    constructor(ILendingPoolAddressesProvider _provider) public {
        addressesProvider = _provider;
    }

    function () external payable {
    }

    function transferFundsBackToPoolInternal(address _reserve, uint _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core,_reserve, _amount);
    }

    function transferInternal(address payable _destination, address _reserve, uint  _amount) internal {
        if(_reserve == INetworkMetadataProvider(addressesProvider.getNetworkMetadataProvider()).getEthereumAddress()) {
            _destination.transfer(_amount);
            return;
        }

        IERC20(_reserve).safeTransfer(_destination, _amount);


    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == INetworkMetadataProvider(addressesProvider.getNetworkMetadataProvider()).getEthereumAddress()) {

            return _target.balance;
        }

        return IERC20(_reserve).balanceOf(_target);

    }
}
