pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract Bank {
    using SafeMath for uint;
    mapping(address => uint) balance;
    
    constructor(uint _balance) public {
        balance[msg.sender] = _balance;
    }
    
    function viewBalance() public view returns(uint) {
        return balance[msg.sender];
    }
    
    function deposit(uint amount) external {
        require(amount > 0);
        balance[msg.sender] = balance[msg.sender].add(amount);
    }
    
    function withdraw(uint amount) external {
        require(amount > 0);
        require((balance[msg.sender].sub(amount)) > 0);
        balance[msg.sender] = balance[msg.sender].sub(amount);
    }
}
