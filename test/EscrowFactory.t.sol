// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test, console} from "forge-std/Test.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
contract EscrowFactoryTest is Test
{
    EscrowFactory escrowFactory;
    address payer = address(1);
    address payee = address(2);
    address escrowAgent = address(3);
    function setUp() external
    {
        escrowFactory = new EscrowFactory();
    }
    function test_CreateEscrow() external
    {
        vm.expectEmit(true, true, true, false);
        emit EscrowFactory.EscrowCreated(address(0));
        escrowFactory.createEscrow(payer, payee, escrowAgent);
        uint escrowsCount = escrowFactory.getEscrowsCount();
        address result = escrowFactory.getEscrow(0);
        assertEq(escrowsCount, 1);
        assertNotEq(result, address(0));
    }
    function test_getEscrow_RevertIf_InvalidIndex() external
    {
        uint escrowsCount = escrowFactory.getEscrowsCount();
        vm.expectRevert(EscrowFactory.InvalidEscrowIndex.selector);
        address result = escrowFactory.getEscrow(escrowsCount);
    }
}