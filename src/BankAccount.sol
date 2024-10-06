// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract BankAccount
{
    mapping(address => uint256) balances;
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    error DepositAmountMustBeGreaterThanZero();
    error InsufficientBalance();
    error TransferFailed();
    function deposit() external payable
    {
        require(msg.value > 0, DepositAmountMustBeGreaterThanZero());
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw(uint256 _amount) external
    {
        require(balances[msg.sender] >= _amount, InsufficientBalance());
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, TransferFailed());
        balances[msg.sender] -= _amount;
        emit Withdrawal(msg.sender, _amount);
    }
    function getBalance() external view returns (uint256)
    {
        return balances[msg.sender];
    }
    function getBalanceOf(address _account) external view returns (uint256)
    {
        return balances[_account];
    }
}
