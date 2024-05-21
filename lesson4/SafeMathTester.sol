// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// safe math 测试
// 在 0.8.0 之前的版本，无符号整型和整型是运行在 unchecked 这个概念之下的
// 在 0.8.0 版本之后，会进行checked，调用add方法，则会失败，因为已经到了最大值了
// 它会自动检查你要操作的数据是超过上限还是下限了
contract SafeMathTester {

    // uint8 的最大值为255, 并且已经赋值为255了
    uint8 public bigNumber = 255; // unchecked 也就是说如果你超过一个数字的上限，它会绕回去从初始值开始，

    // 但是高版本的可以使用 unchecked 关键自包围某段代码，使其成为不检查的代码块
    function add() public {
        unchecked {bigNumber = bigNumber + 1;}
    }
}
