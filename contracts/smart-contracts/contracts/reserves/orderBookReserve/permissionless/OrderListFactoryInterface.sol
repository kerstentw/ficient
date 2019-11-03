pragma solidity 0.5.8;


import "./OrderListInterface.sol";


interface OrderListFactoryInterface {
    function newOrdersContract(address admin) public returns(OrderListInterface);
}
