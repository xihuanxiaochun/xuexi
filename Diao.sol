pragma solidity^0.6.0;

import"./ERC20.sol";

contract DIAO_Demo {
    address public admin;
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address=>uint256) private _balances;
    mapping(address => mapping(address=>uint256)) private _allowance;
    

    constructor(string memory name,string memory symbol) public{
        _name = name;
        _symbol = symbol;
        _totalSupply = 0;
        admin = msg.sender;
    }
    //tokenName
    function name() external view returns(string memory){
        return _name;
    }
    //符号
    function symbol() public view returns (string memory){
        return _symbol;
    }

    // 挖矿函数
    function mint(address to,uint256 value) public{
        require( admin == msg.sender,"only admin can do this" );
        require(address(0) !=to,"spender must an address");
        _balances[to] += value;
        _totalSupply += value;
    }
    
    //总发行量
    function totalSupply() external view returns (uint256){
        return _totalSupply;
    }
    //查询地址的余额
    function balanceOf(address who) external  view returns (uint256){
        return _balances[who];
    }

    function allowance(address owner, address spender)
        external view returns (uint256){
            return _allowance[owner][spender];
    }
    //转账
    function transfer(address to, uint256 value) external returns (bool){
        require(value > 0,"value must >0" );
        require(_balances[msg.sender]>=value,"balance must > value");
        require(address(0) !=to,"to must an address");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender,to,value);
    }

    //授权
    function approve(address spender, uint256 value)
        external returns (bool){
            require(value > 0,"value must >0" );
            //将value设置为0 = 取消授权
            require(_balances[msg.sender]>=value,"balance must > value");
            require(address(0) !=spender,"spender must an address");
            _allowance[msg.sender][spender] = value;
            emit Approval(msg.sender,spender,value);

    }
    //转账
    function transferFrom(address from, address to, uint256 value)
        external returns (bool){
            require(address(0) !=to,"to must an address");
            require(value > 0,"value must >0" );
            require(_allowance[from][to] >= value,"allowance's value must enough!");
            require(_balances[from] >= value,"_balances[from] must enough!");
            require(msg.sender == to,"msg.sender must == to");
            _allowance[from][to] -= value;
            //扣掉授权金额
            _balances[from] -= value;
            //账本减少支付方的余额
            _balances[to] +=value;
            //账本增加支付方的余额
            emit Transfer(from,to,value);
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

}
