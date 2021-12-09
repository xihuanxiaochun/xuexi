pragma solidity ^0.6.0;

contract bank_demo{

    mapping(address => uint256) public balance;//用户的地址映射用户的余额
    string public bankName;
    uint256 totalAmount;
    address public admin;
    string name;

    constructor() public {
        admin = msg.sender;
        bankName = name;
        totalAmount = 0;

    }

    //存钱
    function deposit(uint256 amount) external payable{
        require(amount > 0 ,"amount must > 0 ");
        require(msg.value == amount ,"amount must equal msg.value ");
        balance[msg.sender] += amount;
        totalAmount += amount;
        require(totalAmount == address(this).balance);
    }
    //提现
    function withdraw(uint256 amount) external payable{
        require(amount > 0 ,"amount must > 0 ");
        require(balance[msg.sender] >= amount ,"balance must enough");
        msg.sender.transfer(amount);
        balance[msg.sender] -= amount;
        totalAmount -= amount;
        require(totalAmount == address(this).balance);
    }

    //转账

    function transfer(address to ,uint256 amount) external {
        require(to != msg.sender,"to.address can not != msg.sender");
        require(amount > 0 ,"amount must > 0 ");
        require(balance[msg.sender] >= amount,"balance must enough");
        require(address(0) != to,"to must is a address");
        balance[msg.sender] -=amount;
        balance[to] += amount;
        require(totalAmount == address(this).balance);
    }

    //查询余额
    function getBlance()public view returns(uint256){
        return balance[msg.sender];
    }

    //银行存款
    function getTotalAmount()public view returns(uint256){
        require(msg.sender == admin,'only admin');
        return (address(this).balance);
    }

    function setName(string memory _name)public{
        require(msg.sender == admin,'only admin');
        bankName = _name;
    }

}
