// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface DBCStakingContract {
    function getMachineInfo(string calldata machineId) external view returns (address machineOwner,uint256 calcPoint,uint256 cpuRate,string calldata gpuType, uint256 gpuMem,string calldata cpuType, uint256 gpuCount);
}