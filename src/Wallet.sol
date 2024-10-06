// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
import {ICharity} from "./ICharity.sol";
contract Wallet
{
    ICharity public charity;
    uint256 public constant CHARTY_PERCENTAGE = 50; // == 5.0%
    error NotEnoughDeposit();
    error NotEnoughMoney();
    error TransferFailed();
    error NotOwner();
    address public owner;
    constructor(address _charityAddress)
    {
        owner = msg.sender;
        charity = ICharity(_charityAddress);
    }
    modifier onlyOwner()
    {
        require(msg.sender == owner, NotOwner());
        _;
    }
    function deposit() external payable
    {
        if (msg.value == 0) revert NotEnoughDeposit();
        // division by 1000 not by 100 because charity percentage is 50 (which stands for 5.0) instead of 5
        uint256 charityAmount = (msg.value * CHARTY_PERCENTAGE) / 1000;
        charity.donate{value: charityAmount}();
    }
    function withdraw(uint256 amount) external onlyOwner
    {
        if (amount > address(this).balance) revert NotEnoughMoney();
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert TransferFailed();
    }
}
