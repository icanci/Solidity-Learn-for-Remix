// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackExample {
    constructor(){

    }

    uint256 public result;

    // 特殊函数，只要我们发送ETH或者向这个合约发送交易
    // 只要没有与该交易相关的数据，这个函数就会被触发，类似vue中的钩子函数、生命周期函数
    // 当你向合约发送交易的时候，如果没有指定某个函数。receive 函数就会被触发(当 calldata 没有值的时候)
    receive() external payable {
        result = 1;
    }

    // 即使数据和交易一起被发送，他也会触发
    fallback() external payable {
        result = 2;
    }
}
