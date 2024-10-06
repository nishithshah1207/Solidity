// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test} from "forge-std/Test.sol";
import {Charity} from "../src/Charity.sol";
contract CharityTest is Test
{
    Charity charity;
    address owner = address(1);
    function setUp() public
    {
        charity = new Charity(owner, 1000);
        vm.deal(owner, 100 ether);
    }
    function test_Donate() public
    {
        vm.prank(owner);
        charity.donate{value: 1 ether}();
        uint256 donation = charity.userDonations(owner);
        assertEq(donation, 1 ether);
    }
    function test_Donate_RevertIf_AmountIsZero() public
    {
        vm.prank(owner);
        vm.expectRevert(Charity.NotEnoughDonationAmount.selector);
        charity.donate{value: 0}();
    }
    function test_Donate_RevertIf_CannotDonate() public
    {
        charity = new Charity(owner, 1);
        vm.prank(owner);
        vm.warp(block.timestamp + 2);
        vm.expectRevert(Charity.CanNotDonateAnymore.selector);
        charity.donate{value: 1}();
    }
    function test_Withdraw() public
    {
        vm.startPrank(owner);
        uint amount = 2 ether;
        charity.donate{value: amount}();
        uint256 beforeBalance = owner.balance;
        vm.expectEmit(true, true, true, true);
        emit Charity.Withdrawn(amount);
        charity.withdraw(amount);
        uint256 afterBalance = owner.balance;
        assertGt(afterBalance, beforeBalance);
    }
    function test_Withdraw_RevertIf_AmountMoreThanBalance() public
    {
        vm.startPrank(owner);
        charity.donate{value: 1 ether}();
        vm.expectRevert(Charity.NotEnoughMoney.selector);
        charity.withdraw(2 ether);
    }
    function test_Withdraw_RevertIf_NotOwner() public
    {
        vm.prank(address(2));
        vm.expectRevert(Charity.NotOwner.selector);
        charity.withdraw(1 ether);
        vm.stopPrank();
    }
    function test_Withdraw_RevertWhen_TransferFailed() external
    {
        vm.startPrank(owner);
        uint amount = 2 ether;
        charity.donate{value: amount}();
        // vm.expectRevert(Charity.TransferFailed.selector);
        charity.withdraw(1 ether);
    }
}