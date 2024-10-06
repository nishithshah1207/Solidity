// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract Escrow
{
    address public payer;
    address public payee;
    address public escrowAgent;
    uint256 public amount;
    bool public isFundsDeposited;
    bool public isFundsReleased;
    error OnlyEscrowAgent();
    error OnlyPayer();
    error FundsAlreadyDeposited();
    error FundsNotDeposited();
    error DepositAmountZero();
    error FundsAlreadyReleased();
    error TransferFailed();
    event FundsDeposited(address indexed payer, uint256 amount);
    event FundsReleased(address indexed payee, uint256 amount);
    constructor(address _payer, address _payee, address _escrowAgent)
    {
        payer = _payer;
        payee = _payee;
        escrowAgent = _escrowAgent;
    }
    function deposit() external payable
    {
        require(msg.sender == payer, OnlyPayer());
        require(!isFundsDeposited, FundsAlreadyDeposited());
        require(msg.value > 0, DepositAmountZero());
        amount = msg.value;
        isFundsDeposited = true;
        emit FundsDeposited(msg.sender, msg.value);
    }
    function releaseFunds() external
    {
        require(msg.sender == escrowAgent, OnlyEscrowAgent());
        require(isFundsDeposited, FundsNotDeposited());
        require(!isFundsReleased, FundsAlreadyReleased());
        isFundsReleased = true;
        (bool success, ) = payable(payee).call{value: amount}("");
        require(success, TransferFailed());
        emit FundsReleased(payee, amount);
    }
}
