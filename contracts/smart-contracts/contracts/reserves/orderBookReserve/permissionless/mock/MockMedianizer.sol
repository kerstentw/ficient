pragma solidity 0.5.8;


contract MockMedianizer {

    uint dollarPerEthPrecision;
    bool valid = true;

    function setEthPrice(uint dollarPerEth) public {
        dollarPerEthPrecision = dollarPerEth;
    }

    function setValid(bool isValid) public {
        valid = isValid;
    }

    function peek() public view returns (bytes32, bool) {
        return(bytes32(dollarPerEthPrecision), valid);
    }
}
