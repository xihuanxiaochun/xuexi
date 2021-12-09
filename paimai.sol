pragma solidity^0.6.0;

contract aution_demo{
    address payable public seller;
    address payable public buyer;
    uint256 public highAmount;
    address public admin;
    string autionName;
    bool isFinshed;
    uint256 outTime;
    bool once;

    constructor(string memory _name)public{
        autionName = _name;
        seller = msg.sender;
        admin = msg.sender;
        isFinshed = false;
        outTime = now + 20;
        highAmount = 0;
    }

    //拍卖
    function aution()public payable{
        require(msg.value > highAmount,"amount must > highAmount");
        require(msg.sender != buyer,'msg.sender != buyer');
        //除非最高出价人已经被改变，否则不能进行第二次报价
        require(!isFinshed,"isFinshed is true");
        require(now <= outTime,"now must <= outTime");
        buyer.transfer(highAmount);
        buyer = msg.sender;
        highAmount = msg.value;
    }

    //结束拍卖
    function endAuction() public payable{
        require(msg.sender == admin,"only admin can do this");
        require(now > outTime,"time is not ok");
        require(!isFinshed,"must not Finshed");
        isFinshed = true;
        seller.transfer(highAmount * 90 /100);
    }
}
