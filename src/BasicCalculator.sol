// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract BasicCalculator
{
    function add(int256 a, int256 b) external pure returns (int256)
    {
        return a + b;
    }
    function subtract(int256 a, int256 b) external pure returns (int256)
    {
        return a - b;
    }
    function multiply(int256 a, int256 b) external pure returns (int256)
    {
        return a * b;
    }
    function divide(int256 a, int256 b) external pure returns (int256)
    {
        require(b != 0, "Calculator: Cannot divide by zero");
        return a / b;
    }
}