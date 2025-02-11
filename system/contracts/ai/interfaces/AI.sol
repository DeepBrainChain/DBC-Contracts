// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


interface DBCAIContract {
    enum StakingType {
        ShortTerm,
        LongTerm,
        Free
    }
    function getMachineState(string calldata machineId, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered);

    function getMachineInfo(string calldata machineId) external view returns (address machineOwner,uint256 calcPoint,uint256 cpuRate,string memory gpuType, uint256 gpuMem,string memory cpuType,uint256 gpuCount);

    function reportStakingStatus(string calldata projectName, StakingType stakingType, uint256 gpuNum, bool isStake) external;

}