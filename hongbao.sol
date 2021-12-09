pragma solidity ^0.6.0;


contract redpackre_demo{
    address payable public tuhao;
    uint256 rcount;
    uint256 randnum;
    mapping(address => bool) isStake;

    //1.发红包

    constructor(uint count) public payable{

        require(msg.value>0,"msg.value must > 0 ");
        require(count>0,"msg.value must > 0 ");
        rcount = count;
        tuhao = msg.sender;

    }

    //2.抢红包

    function stakeMoney() public payable{
        require(isStake[msg.sender] == false,"Stake must be true");
        require(rcount >0 , "rcount must > 0");
        require(getRcountBalance()> 0,"Balace must>0");
        randnum = uint256(keccak256(abi.encode(msg.sender,tuhao,now,rcount))) % 100;
        msg.sender.transfer(randnum*getRcountBalance()/100);
        rcount --;
        isStake[msg.sender] = true;
    }

    //获得当前合约的余额
    function getRcountBalance() public view returns(uint256) {
        return address(this).balance;

    }

    //3.退回
    function kill() public payable{
        selfdestruct(tuhao);
        // tuhao.transfer(address(this).balance);
    }

    function getRcount() public view returns(uint){
        return rcount;

    }

}
