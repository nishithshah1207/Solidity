// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
contract EscrowTest is Test
{
    Escrow escrow;
    address payer = address(1);
    address payee = address(2);
    address escrowAgent = address(3);
    address nonPayer = address(4);
    address nonEscrowAgent = address(5);
    uint amount = 1 ether;
    function setUp() external
    {
        escrow = new Escrow(payer, payee, escrowAgent);
    }
    function test_Deposit() external
    {
        hoax(payer, amount);
        vm.expectEmit(true, true, true, true);
        emit Escrow.FundsDeposited(payer, amount);
        escrow.deposit{value: amount}();
        bool isFundsDeposited = escrow.isFundsDeposited();
        uint _amount = escrow.amount();
        assertTrue(isFundsDeposited);
        assertEq(_amount, amount);
    }
    function test_Deposit_RevertWhen_DepositByNonPayer() external
    {
        hoax(nonPayer, amount);
        vm.expectRevert(abi.encodeWithSelector(Escrow.OnlyPayer.selector));
        escrow.deposit{value: amount}();
    }
    function test_Deposit_RevertWhen_AlreadyDeposited() external
    {
        hoax(payer, amount);
        escrow.deposit{value: amount}();
        hoax(payer, amount);
        vm.expectRevert(abi.encodeWithSelector(Escrow.FundsAlreadyDeposited.selector));
        escrow.deposit{value: amount}();        
    }
    function test_Deposit_RevertWhen_DepositAmountIsZero() external
    {
        vm.prank(payer);
        vm.expectRevert(abi.encodeWithSelector(Escrow.DepositAmountZero.selector));
        escrow.deposit();
    }
    function test_ReleaseFunds() external
    {
        hoax(payer, amount);
        escrow.deposit{value: amount}();
        vm.prank(escrowAgent);
        vm.expectEmit(true, true, true, true);
        emit Escrow.FundsReleased(payee, amount);
        escrow.releaseFunds();
        bool isfundsReleased = escrow.isFundsReleased();
        assertTrue(isfundsReleased);
    }
    function test_ReleaseFunds_RevertWhen_NotEscrowAgent() external
    {
        hoax(payer, amount);
        escrow.deposit{value: amount}();
        vm.prank(nonEscrowAgent);
        vm.expectRevert(abi.encodeWithSelector(Escrow.OnlyEscrowAgent.selector));
        escrow.releaseFunds();
    }
    function test_ReleaseFunds_RevertWhen_NoFundsDeposited() external
    {
        vm.prank(escrowAgent);
        vm.expectRevert(abi.encodeWithSelector(Escrow.FundsNotDeposited.selector));
        escrow.releaseFunds();
    }
    function test_ReleaseFunds_RevertWhen_AlreadyReleased() external
    {
        hoax(payer, amount);
        escrow.deposit{value: amount}();
        vm.prank(escrowAgent);
        escrow.releaseFunds();
        vm.prank(escrowAgent);
        vm.expectRevert(abi.encodeWithSelector(Escrow.FundsAlreadyReleased.selector));
        escrow.releaseFunds();
    }
    function test_ReleaseFunds_RevertWhen_TransferFailed() external
    {
        escrow = new Escrow(payer, address(this), escrowAgent);
        hoax(payer, amount);
        escrow.deposit{value: amount}();
        vm.prank(escrowAgent);
        vm.expectRevert(abi.encodeWithSelector(Escrow.TransferFailed.selector));
        escrow.releaseFunds();
    }
}