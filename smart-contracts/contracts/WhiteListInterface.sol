pragma solidity 0.5.8;


contract WhiteListInterface {
    function getUserCapInWei(address user) external view returns (uint userCapWei);
}
