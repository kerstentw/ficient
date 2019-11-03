pragma solidity 0.5.8;


import "./ERC20Interface.sol";

interface SanityRatesInterface {
    function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
}
