// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

// FundMe 合约
// 其是一个智能合约，可以使人们发起一个众筹
// 人们可以向其发送ETH、Polygon、Fantom 或者是其他区块链原生通证

// 要求
// 这个合约可以从用户那里获取资金
// 可以提取资金
// 设置一个以 usd 计价的最小资助金额
contract FundMe {
    constructor() {
    }

    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;

    mapping(address => uint256) public  addressToAmountFunded;

    // fund 函数，人们可以使用其来发送资金
    // paybale 关键字
    // 就像我们的钱包可以持有资金，合约地址也可以持有资金
    // 每次部署合约的时候，可以获得一个合约地址，这个地址和钱包地址几乎一致
    // 所以钱包和合约都可以持有像是ETH这样的原生区块链通证

    // 当人们给这个合约发送资金的时候，我们想要记录下来这些人
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

        // getConversionRate 需要传入一个参数，但是msg.value
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough! ");
        // 记录下每个 funder
        // msg.sender 是一个全局关键字 表示是调用这个函数的地址 即 Account address
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // 合约的拥有者可以提取不同的funder发生的资金
    // 因为我们要提取资金，所以需要把上面存储的数据设置为0
    function withdraw() public {
        // for loop
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            // code
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // 重置数组 后面的 0 表示没有一个元素在里面，如果是1，则说明有1个元素在里面
        funders = new address[](0);
        // 发送资金: 我们如何实际从这个合约中提取资金呢？

    }
}
