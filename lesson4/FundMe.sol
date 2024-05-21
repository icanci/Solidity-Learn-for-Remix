// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

// 优化之前
// 创建此合约需要的 gas：840761
// Immutable Constant(常量)
// 使用 Constant 修饰 minimumUsd
// 创建此合约需要的 gas：821214

// FundMe 合约
// 其是一个智能合约，可以使人们发起一个众筹
// 人们可以向其发送ETH、Polygon、Fantom 或者是其他区块链原生通证

// 要求
// 这个合约可以从用户那里获取资金
// 可以提取资金
// 设置一个以 usd 计价的最小资助金额
error NotOwner();


contract FundMe {
    // 构造函数，会在你部署合约之后立即调用一次
    constructor() {
        // 这里的 sender 就是部署这个合约的人
        i_owner = msg.sender;
    }

    using PriceConverter for uint256;

    // 对于 Solidity 中只需要设置一次的变量 可以通过优化，来节省gas
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;

    mapping(address => uint256) public  addressToAmountFunded;

    address public immutable i_owner;

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
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough! ");
        // 记录下每个 funder
        // msg.sender 是一个全局关键字 表示是调用这个函数的地址 即 Account address
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        //
    }

    // 合约的拥有者可以提取不同的funder发生的资金
    // 因为我们要提取资金，所以需要把上面存储的数据设置为0
    // 此时，无论是谁都可以从这个合约提款；我们不希望所有人都可以提款
    // 所以我们需要设定只有合约的拥有者才能调用 withdraw 函数
    function withdraw() public onlyOwner {
        // 当前的调用者和创建合约的，是否是一个人
        // require(msg.sender == owner,"Sender is not owner! ");

        // for loop
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            // code
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // 重置数组 后面的 0 表示没有一个元素在里面，如果是1，则说明有1个元素在里面
        funders = new address[](0);
        // 发送资金: 我们如何实际从这个合约中提取资金呢？或者说我们该如何把资金发送给合约的调用者
        // 如何需要发送以太币或者其他区块链原生货币的话，有三种不同的方式可供使用
        // transfer this 表示整个合约本身 .balance 就是当前这个地址的区块链原生货币或者以太坊余额了
        // 这里还是要做一个类型转换，把 msg.sender 从address类型转为 payable address 类型

        // msg.sender = address
        // call 是在 Solidity 中比较底层的命令。可以用来调用几乎所有的Solidity函数
        // 如果函数调用成功，那么就返回true 否则返回false
        // dataReturned 指的是 我们调用那个函数本身就返回一些数据或者说有返回值，那么就是此值
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed!");
    }

    // 修饰器
    // 意思使用 onlyOwner 标记的函数，必须在调用之前，先调用一下 onlyOwner 里面的函数，再运行下划线的代码，下划线的代码表示剩余的代码
    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner! ");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // 如果有人在没t有调用fund函数就向这个合约发送以太币的情况下，怎么处理
    // 特殊函数
    // receive()
    // fallback()

    // 特殊函数，只要我们发送ETH或者向这个合约发送交易
    // 只要没有与该交易相关的数据，这个函数就会被触发，类似vue中的钩子函数、生命周期函数
    // 当你向合约发送交易的时候，如果没有指定某个函数。receive 函数就会被触发(当 calldata 没有值的时候)
    receive() external payable {
        fund();
    }

    // 即使数据和交易一起被发送，他也会触发
    fallback() external payable {
        fund();
    }
}
