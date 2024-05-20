// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

import "./SimpleStorage.sol";

// 我们可以理解为 ExtraStorage 是 SimpleStorage 的子合约
contract ExtraStorage is SimpleStorage {
    // + 5
    // 重载
    // virtual override
    function store(uint256 _favorableNumber) public override {
        favorableNumber = _favorableNumber + 5;
    }
}