pragma solidity 0.5.8;


import "./OrderListFactoryInterface.sol";


interface OrderbookReserveInterface {
    function init() public returns(bool);
    function kncRateBlocksTrade() public view returns(bool);
}
