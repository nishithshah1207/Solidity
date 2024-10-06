// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;
import {Test, console} from "forge-std/Test.sol";
import {HelloWorld} from "../src/HelloWorld.sol";
contract HelloWorldTest is Test
{
    HelloWorld public hw;
    function setUp() public
    {
        hw = new HelloWorld();
    }
    function test_GetMessage() external
    {
        string memory expectedMessage = "Hello World";
        string memory result = hw.getMessage();
        assertEq(expectedMessage, result);
    }
}
