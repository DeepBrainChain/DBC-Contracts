// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface DBCStakingContract {
    function freeGpuAmount(string calldata _id) external view returns (uint256);
    function reportStakingStatus(string calldata _id, uint256 gpuNum, bool isStake) external;
}