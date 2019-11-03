pragma solidity ^0.5.8;


import "../Withdrawable.sol";


contract MockWithdrawable is Withdrawable {
    function () public payable { }
}
