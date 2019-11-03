pragma solidity 0.5.8;


import "./OrderList.sol";


contract OrderListFactory {
    function newOrdersContract(address admin) public returns(OrderListInterface) {
        OrderList orders = new OrderList(admin);
        return orders;
    }
}
