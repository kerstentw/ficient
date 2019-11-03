pragma solidity ^0.5.1;

interface IArbRails {
    
    function exchange(address _from, uint amount, address _to) external;
}