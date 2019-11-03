pragma solidity ^0.4.18;

import "./IArbRail.sol";
import "http://github.com/KyberNetwork/smart-contracts/blob/master/contracts/KyberNetworkProxy.sol";


contract KyberArbRail is IArbRail {
    ERC20 ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
    address zero_address = 0x0000000000000000000000000000000000000000;
    
    KyberNetworkProxy kyberProxyAddress = KyberNetworkProxy(0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D);
    
    function exchange(address _from, uint amount, address _to) public payable {
        if (_from == zero_address) {
            swapEtherToToken(kyberProxyAddress, ERC20(_to), msg.sender);
        } else if (_to == zero_address) {
            swapTokenToEther(kyberProxyAddress, ERC20(_to), amount, msg.sender);
        }
    }
    
    //@param _kyberNetworkProxy kyberNetworkProxy contract address
    //@param token source token contract address
    //@param tokenQty token wei amount
    //@param destAddress address to send swapped ETH to
    function swapTokenToEther (KyberNetworkProxy _kyberNetworkProxy, ERC20 token, uint tokenQty, address destAddress) public {
    
        uint minRate;
        (, minRate) = _kyberNetworkProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, tokenQty);
    
        // Check that the token transferFrom has succeeded
        require(token.transferFrom(msg.sender, address(this), tokenQty));
    
        // Mitigate ERC20 Approve front-running attack, by initially setting
        // allowance to 0
        require(token.approve(address(_kyberNetworkProxy), 0));
    
        // Approve tokens so network can take them during the swap
        token.approve(address(_kyberNetworkProxy), tokenQty);
        uint destAmount = _kyberNetworkProxy.swapTokenToEther(token, tokenQty, minRate);
    
        // Send received ethers to destination address
        destAddress.transfer(destAmount);
    }
    
    //@dev assumed to be receiving ether wei
    //@param _kyberNetworkProxy kyberNetworkProxy contract address
    //@param token destination token contract address
    //@param destAddress address to send swapped tokens to
    function swapEtherToToken (KyberNetworkProxy _kyberNetworkProxy, ERC20 token, address destAddress) public payable {
    
        uint minRate;
        (, minRate) = _kyberNetworkProxy.getExpectedRate(ETH_TOKEN_ADDRESS, token, msg.value);
    
        //will send back tokens to this contract's address
        uint destAmount = _kyberNetworkProxy.swapEtherToToken.value(msg.value)(token, minRate);
    
        //send received tokens to destination address
        require(token.transfer(destAddress, destAmount));
    }
    
}

