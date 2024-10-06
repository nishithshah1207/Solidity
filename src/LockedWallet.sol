// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract LockedWallet
{
    address payable public beneficiary;
    uint public withdrawalTime;
    error WithdrawalTimeNotReachedYet(uint256 timeRemaining);
    error TransferFailed();
    constructor(uint duration, address payable _beneficiary) payable
    {
        withdrawalTime = block.timestamp + duration;
        beneficiary = _beneficiary;
    }
    function withdraw() external
    {
        if (withdrawalTime > block.timestamp)
            revert WithdrawalTimeNotReachedYet(withdrawalTime - block.timestamp);
        (bool success, ) = beneficiary.call{value: address(this).balance}("");
        if (!success) revert TransferFailed();
    }
}
