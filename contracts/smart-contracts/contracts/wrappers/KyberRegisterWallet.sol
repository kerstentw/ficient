pragma solidity 0.5.8;


interface BurnerWrapperProxy {
    function registerWallet(address wallet) public;
}


contract KyberRegisterWallet {

    BurnerWrapperProxy public feeBurnerWrapperProxyContract;

    function KyberRegisterWallet(BurnerWrapperProxy feeBurnerWrapperProxy) public {
        require(feeBurnerWrapperProxy != address(0));

        feeBurnerWrapperProxyContract = feeBurnerWrapperProxy;
    }

    function registerWallet(address wallet) public {
        feeBurnerWrapperProxyContract.registerWallet(wallet);
    }
}
