// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    // default uint value is zero
    uint256 favorableNumber;

    uint256 public borthersFavorableNumber;

    // People public person = People({favorableNumber:9,name:"icanci"});

    // 创建列表的方法是使用一组被称为数组(array)的数据结构
    // array 是存储列表，或者说存储一系列对象的一种方式
    // 创建一个数组的方法和初始化其他类型没有什么区别

    // 此时这两个数组还是空列表
    // 这种类型的数组就是所谓的动态数组 (dynamic array) 因为在初始化这个数组的时候并没有规定他的大小
    // 没有设置大小，那就是任意大小，并且数组的大小会随着我们添加和减少而增加和减少
    People[] public peoples;
    uint256[] public favorableNumbers;
    // 如果在中括号中声明长度，那么如 3 则表明这个数组的可以容纳的个数为3 
    uint256[3] public fixedSizeFavorableNumbers;

    // 映射
    mapping(string => uint256) public nameToFavorableNumber;

    // 结构体
    struct People {
        uint256 favorableNumber;
        string name;
    }

    // 函数或者方法指的是独立模块，在我们调用的时候会执行某些指令

    // 函数 通过关键字 function 来修饰
    function store(uint256 _favorableNumber) public {
        favorableNumber = _favorableNumber;
        retrieve();
    }

    // function something() public {
    //     testVar = 6;
    // }

    function retrieve() public view returns (uint256){
        return favorableNumber;
    }

    function add() public pure returns (uint256){
        return 1 + 1;
    }

    // calldata、memory、storage
    // calldata 和 memory 意味着这个变量只是临时存在
    // 所以这个 _name 变量仅在调用此 addPerson() 函数的 transaction 交易期间，暂时存在

    // storage 存储变量甚至存在于正在执行的函数之外
    // 尽管 favorableNumber 没有声明类型，但是其自动分配为一个存储变量

    // 因为在这个函数执行完毕之后，我们就不需要这个 _name 了，所以将其声明为 memory 或者 calldata
    // calldata 是不可被修改的临时变量，类似final
    // memory 是可以被修改的临时变量
    // storage 是可以被修改的永久变量

    // 但是为什么 string 类型的需要 memory 修饰，但是 uint256 不需要？
    // 因为数组、结构体、映射 在 Solidity中被认为是特殊的类型
    // 但是string的本质就是bytes数组，所以其也需要，但是 uint256 可以自动知道 uint256 的位置 => Solidity 知道对于这个函数
    // uint256 将仅仅存在于内存中，但是不确定 string 是什么
    function addPerson(string memory _name, uint256 _favorableNumber) public {
        // 这里的 push 的People 是大小的，其实就是结构体的名字
        // 而里面的参数，使用() 包括的，就是其有参构造方法
        People memory newPeople = People({favorableNumber: _favorableNumber, name: _name});
        // People memory newPeople2 = People(_favorableNumber,_name);

        // peoples.push(People(_favorableNumber,_name));
        peoples.push(newPeople);

        nameToFavorableNumber[_name] = _favorableNumber;
    }

} 
