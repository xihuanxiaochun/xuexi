pragma solidity 0.4.24;

    //安全计算公式
    contract SafeMath {
        function safeSub(uint256 a, uint256 b) internal returns (uint256) {
            assert(b <= a);
            return a - b;
        }
        function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
            uint256 c = a + b;
            assert(c>=a && c>=b);
            return c;
        }
        }
    //管理员设置
    contract owned {
        //合同创建者是管理员
        address public owner;
        constructor() public {
            owner = msg.sender;
        }
        //自定义修饰符
        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }
        //管理员权限修改
        function transferOwnership(address newOwner) onlyOwner public {
            if (newOwner != address(0)) {
            owner = newOwner;
        }
        }
    }
    //Token合约
    contract HEAToken is SafeMath,owned {
        string public name="C-money";
        string public symbol="$$";
        uint8 public decimals = 18;
        uint256 public totalSupply=30000000000000; 
        mapping (address => uint256) public balanceOf;
        //余额映射
        mapping (address => mapping (address => uint256)) public allowance;
        //授权映射
        mapping (address => bool) public frozenAccount;
        //冻结地址
        event Transfer(address indexed from, address indexed to, uint256 value);
        //交易事件
        event Freeze(address indexed from, bool frozen);
        //冻结事件

        //定义初始供应量initialSupply，代币名称，代币符号
        constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
            totalSupply = initialSupply * 10 ** uint256(decimals);
            // 发行量 = 输入数量*10*18位小数点，进行覆盖
            balanceOf[msg.sender] = totalSupply;
            //为创建合约的钱包地址增加发行量
            name = tokenName;
            //将输入的name赋值给name
            symbol = tokenSymbol;
            //代币符号进行替换
    }
    //转账规则
    function _transfer(address _from, address _to, uint256 _value) internal {
      require(_to != 0x0);
      //接收者不能为空地址
      require(_value > 0);
      //转账金额必须大于0
      require(balanceOf[_from] >= _value);
      //From的余额必须大于转账金额
      require(balanceOf[_to] + _value > balanceOf[_to]);
      //to的余额+转账金额必须大于to的余额
      require(!frozenAccount[_from]);
      //from不能是被冻结用户
      require(!frozenAccount[_to]);
      //to不能是被冻结用户
      uint previousBalances = SafeMath.safeAdd(balanceOf[_from] , balanceOf[_to]);
      //历史余额总和 = Add方法（from和to余额的总和）
      balanceOf[_from] = SafeMath.safeSub( balanceOf[_from] , _value);
      //from的余额 = Sub方法（from的余额减去转账金额）
      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] , _value);
      //to的余额 = Add方法（to的余额本次的转账金额）
      emit Transfer(_from, _to, _value);
      //发射交易日志
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
      //断言交易结束后from余额+to余额 = 历史余额总和
    }

    //转账方法
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        //调用转账规则，发送者=_from,_to=_to,_value=_value
        return true;
    }

    //授权转账方法
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      require(_to != 0x0);
      //to不可为空地址
      require(_value > 0);
      //转账金额不可为0 
      require(balanceOf[_from] >= _value);
      //from余额必须大于转账金额
      require(balanceOf[_to] + _value > balanceOf[_to]);
      //to的余额+转账金额必须大于to的余额
      require(!frozenAccount[_from]);
      //from不可是冻结用户
      require(!frozenAccount[_to]);
      //to不可是冻结用户
      require(_value <= allowance[_from][msg.sender]); 
      //转账金额必须小于信息发送人的被授权额度
      uint previousBalances = SafeMath.safeAdd(balanceOf[_from] , balanceOf[_to]);
      //历史余额总和=Add方法（from和to余额的和）
      allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender] , _value);
      //from给调用方的授权额度=sub方法（授权金额-转账金额）
      balanceOf[_from] = SafeMath.safeSub( balanceOf[_from] , _value);
      //from余额 = sub方法（from减去转账金额）
      balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] , _value);
      //to余额 = Add方法（to的余额+转账金额）
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
      //断言交易结束后from余额+to余额 = 历史余额总和
      emit Transfer(_from, _to, _value);
      //发射交易日志
      return true;
    }

    // 授权方法
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != 0x0);
        // 要求接收方不能是空地址
        require(_value > 0);
        // 要求金额>0
        require(balanceOf[msg.sender] >= _value);
        //要求被授权方余额大于等于被授权金额
        require(!frozenAccount[msg.sender]);
        //发送者不可以是被冻结用户
        require(!frozenAccount[_spender]);
        //要求被授权方不可以是被冻结用户
        allowance[msg.sender][_spender] = _value;
        //映射，信息发送者授权给被授权者本次的金额
        return true;
    }
    function freezeMethod(address target, bool frozen) onlyOwner public returns (bool success){
        require(target != 0x0);
        //对象不可是空地址
        frozenAccount[target] = frozen;
        //封禁名单中的目标=布尔值
        emit Freeze(target, frozen);
        //发射封禁日志
        return true;
    }
}
