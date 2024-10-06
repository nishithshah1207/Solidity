// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "./RewardSystem.sol";
contract TieredRewardSystem is RewardSystem
{
    enum Tier { None, Bronze, Silver, Gold }
    mapping(address => Tier) public userTiers;
    uint256 public constant BRONZE_RATE = 1;
    uint256 public constant SILVER_RATE = 2;
    uint256 public constant GOLD_RATE = 3;
    event TierAssigned(address indexed user, Tier tier);
    function assignTier(address user, Tier tier) external
    {
        userTiers[user] = tier;
        emit TierAssigned(user, tier);
    }
    function earnPoints(address user, uint256 points) public override
    {
        Tier userTier = userTiers[user];
        uint256 multiplier = tierMultiplier(userTier);
        uint256 earnedPoints = points * multiplier;
        super.earnPoints(user, earnedPoints);
    }
    function tierMultiplier(Tier tier) internal pure returns (uint256)
    {
        if (tier == Tier.Gold) return GOLD_RATE;
        if (tier == Tier.Silver) return SILVER_RATE;
        if (tier == Tier.Bronze) return BRONZE_RATE;
        return 0;
    }
}