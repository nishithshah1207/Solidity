// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
abstract contract RewardSystem
{
    mapping(address => uint256) public rewardBalances;
    event PointsEarned(address indexed user, uint256 points);
    event PointsRedeemed(address indexed user, uint256 points);
    event PointsTransferred(address indexed from, address indexed to, uint256 points);
    error InsufficientPoints(address user, uint256 requested, uint256 available);
    error InvalidPointsAmount(uint256 points);
    function earnPoints(address user, uint256 points) public virtual
    {
        require(points > 0, InvalidPointsAmount(points));
        rewardBalances[user] += points;
        emit PointsEarned(user, points);
    }
    function redeemPoints(uint256 points) public virtual
    {
        require(rewardBalances[msg.sender] >= points, InsufficientPoints(msg.sender, points, rewardBalances[msg.sender]));
        rewardBalances[msg.sender] -= points;
        emit PointsRedeemed(msg.sender, points);
    }
    function transferPoints(address to, uint256 points) public virtual
    {
        require(rewardBalances[msg.sender] >= points, InsufficientPoints(msg.sender, points, rewardBalances[msg.sender]));
        rewardBalances[msg.sender] -= points;
        rewardBalances[to] += points;
        emit PointsTransferred(msg.sender, to, points);
    }
    function getBalance(address user) public view virtual returns (uint256)
    {
        return rewardBalances[user];
    }
}