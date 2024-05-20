// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FundMe 合约
// 其是一个智能合约，可以使人们发起一个众筹
// 人们可以向其发送ETH、Polygon、Fantom 或者是其他区块链原生通证

// 要求
// 这个合约可以从用户那里获取资金
// 可以提取资金
// 设置一个以 usd 计价的最小资助金额
contract FundMe {

    uint256 public minimumUsd = 50;

    // fund 函数，人们可以使用其来发送资金
    // paybale 关键字
    // 就像我们的钱包可以持有资金，合约地址也可以持有资金
    // 每次部署合约的时候，可以获得一个合约地址，这个地址和钱包地址几乎一致
    // 所以钱包和合约都可以持有像是ETH这样的原生区块链通证

    function fund() public payable {
        // 设置一个以 usd 计价的最小资助金额
        // 1.我们怎么向这个合约转ETH
        // 通过msg.value 可以得知某人转账的金额 单位是 wei
        // revert 将之前的操作回滚，并将剩余的gas返回
        // 比如 fund 函数需要花费 1000gas
        // 在 require 之前，需要花费 50gas
        // 但是在 require 失败，那么则需要返还 1000 - 50 = 950 gas

        // 这里的值是以太，单位是wei 但是我们怎么把以太币转换为usd呢？这就是预言机的作用
        // 为了获取以太币的美元价格，我们需要从区块链之外获得信息
        // 也就是使用去中心化的预言机网络，获取1个ETH的usd价格
        require(msg.value >= minimumUsd, "didn't send enough! ");
    }

    // 合约的拥有者可以提取不同的funder发生的资金
    //    function withdraw()  {
    //
    //    }
}
