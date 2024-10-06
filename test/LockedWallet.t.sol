// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test, console} from "forge-std/Test.sol";
import {LockedWallet} from "../src/LockedWallet.sol";
contract LockedWalletTest is Test
{
    LockedWallet lockedWallet;
    uint duration = 1 days;
    address payable public beneficiary = payable(address(1));
    uint amount = 1 ether;
    function setUp() public
    {
        lockedWallet = new LockedWallet{value: amount}(duration, beneficiary);
    }
    function test_Withdraw() external
    {
        vm.warp(lockedWallet.withdrawalTime());
        lockedWallet.withdraw();
        uint beneficiaryBalance = beneficiary.balance;
        assertEq(address(lockedWallet).balance, 0);
        assertEq(beneficiaryBalance, amount);
    }
    function test_Withdraw_RevertWhen_WithdrawalTimeNotReachedYet() external
    {
        uint withdrawalTime = lockedWallet.withdrawalTime();
        vm.warp(withdrawalTime - 1);
        uint timeRemaining = withdrawalTime - block.timestamp;
        vm.expectRevert(
            abi.encodeWithSelector(
                LockedWallet.WithdrawalTimeNotReachedYet.selector, timeRemaining
            )
        );
        lockedWallet.withdraw();
    }
    function test_Withdraw_RevertWhen_TransferFailed() external
    {
        lockedWallet = new LockedWallet{value: amount}(duration, payable(address(this)));
        vm.warp(lockedWallet.withdrawalTime());
        vm.expectRevert(LockedWallet.TransferFailed.selector);
        lockedWallet.withdraw();
    }
}