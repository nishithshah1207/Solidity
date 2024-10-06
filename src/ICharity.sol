// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
interface ICharity
{
    function donate() external payable;
    function canDonate() external view returns(bool);
}