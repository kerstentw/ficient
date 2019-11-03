pragma solidity 0.5.8;


import "./ERC20Interface.sol";


interface ExpectedRateInterface {
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty, bool usePermissionless) public view
        returns (uint expectedRate, uint slippageRate);
}
