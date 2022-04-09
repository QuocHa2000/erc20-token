// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}


contract HVQToken is IERC20, Ownable {
    using SafeMath for uint256;

    address public ownerAddress;
    string public constant name = "HVQ Token";
    string public constant symbol = "HVQ";
    uint public constant decimals = 18;
    
    mapping (address=>uint256) balances;
    mapping (address=>mapping(address=>uint256)) allowed;

    uint256 totalSupply_;

    constructor (uint256 total) public{
        ownerAddress = msg.sender;
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function totalSupply() public view override returns(uint256){
        return totalSupply_;
    }

    function balanceOf(address addressToCheck) public view override returns (uint256){
        return balances[addressToCheck];
    }

    function transfer(address receiver, uint256 amount) public override returns(bool) {
        require(amount>0, "You are transfering nothing !!!");
        require(balances[msg.sender] >= amount, "Your balance is not enough to transfer");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[receiver] = balances[receiver].add(amount);

        emit Transfer(msg.sender, receiver, amount);

        return true;
        
    }

    function approve(address delegate, uint amount) public override returns(bool) {
        allowed[msg.sender][delegate] = amount;

        emit Approval(msg.sender, delegate, amount);
        
        return true;
    }

    function allowance(address owner, address delegate) public view override returns(uint){
        return allowed[owner][delegate];
    }

    function transferFrom(address owner,address buyer, uint256 amount) public override returns(bool) {
        require(balances[owner] >= amount,"Not enough balances");
        require(allowed[owner][msg.sender] >=amount, "Not enough allowance");

        balances[owner] = balances[owner].sub(amount);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(amount);
        balances[buyer] = balances[buyer].add(amount);

        emit Transfer(msg.sender, buyer, amount);

        return true;
        
    }

    function ownerBalance() public view onlyOwner returns(uint256){
        return balances[ownerAddress];
    }
}