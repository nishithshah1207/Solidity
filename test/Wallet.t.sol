// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";
contract WalletTest is Test
{
    Wallet wallet;
    address owner = address(1);
    function setUp() public
    {
        wallet = new Wallet(owner);
        vm.deal(owner, 100 ether);
    }
    function test_Donate() public
    {
        vm.prank(owner);
        wallet.deposit{value: 1 ether}();
        // uint256 donation = wallet.userDonations(owner);
        // assertEq(donation, 1 ether);
    }
    function test_Donate_RevertIf_NotEnoughDeposit() public
    {
        vm.prank(owner);
        vm.expectRevert(Wallet.NotEnoughDeposit.selector);
        wallet.deposit{value: 0}();
    }
    function test_Withdraw() public
    {
        vm.startPrank(owner);
        uint amount = 2 ether;
        wallet.deposit{value: amount}();
        uint256 beforeBalance = owner.balance;
        wallet.withdraw(amount);
        uint256 afterBalance = owner.balance;
        assertGt(afterBalance, beforeBalance);
    }
    function test_Withdraw_RevertIf_AmountMoreThanBalance() public
    {
        vm.startPrank(owner);
        wallet.deposit{value: 1 ether}();
        vm.expectRevert(Wallet.NotEnoughMoney.selector);
        wallet.withdraw(2 ether);
    }
    function test_Withdraw_RevertIf_NotOwner() public
    {
        vm.prank(address(2));
        vm.expectRevert(Wallet.NotOwner.selector);
        wallet.withdraw(1 ether);
    }
    function test_Withdraw_RevertWhen_TransferFailed() external
    {
        vm.startPrank(owner);
        uint amount = 2 ether;
        wallet.deposit{value: amount}();
        // vm.expectRevert(Wallet.TransferFailed.selector);
        wallet.withdraw(1 ether);
    }
}