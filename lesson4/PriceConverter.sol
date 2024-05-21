// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// remix 可以自动识别 @chainlink/contracts 就是指向 chainlink/contracts de NPM 包
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// library 不能有任何静态变量，也不能发送ETH
// 一个库的所有的function都是internal的
library PriceConverter {

    function getPrice() internal view returns (uint256) {
        // abi
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 创建合约对象
        // (uint80 roundId,int256 price, uint startedAt,uint timestamp, uint80 answerInRound) = dataFeed.latestRoundData();
        // 可以将不关心的数据删除掉，但是需要保留逗号
        // 其中 latestRoundData 的返回值可以返回多个数据
        (,int256 price,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
        // ETH in terms of USD
        // 因为Solidity是不能使用小数的
        return uint256(price * 1e10); // 1 ** 10000000000
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    //
    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        // ethPrice 和 ethAmount 都是18位的，如果不除以18个0，那么就会变成36位
        // such as ethPrice = 3000_000000000000000000 单位是每个ETH的usd价格
        //         ethAmount = 1_000000000000000000 单位是wei
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
