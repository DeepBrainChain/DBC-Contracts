// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface DBCStakingContract {
    function getMachineInfo(string calldata id, bool isDeepLink) external view returns (address machineOwner,uint256 calcPoint,uint256 cpuRate,string calldata gpuType, uint256 gpuMem,string memory cpuType, uint256 gpuCount, string memory machineId);
}