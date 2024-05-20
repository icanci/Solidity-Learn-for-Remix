// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

// 单个 Solidity 文件，可以拥有多个不同的合约
// 这个合约里面，我们可以把 StorageFactory 当做是 SimpleStorage 合约的管理者
contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    // 如果需要和其他的合约进行交互，需要2个东西
    // 合约地址 Address
    // 合约ABI 即 应用程序二进制接口 Application Binary Interface
    function sfStrore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // address
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
    }
}