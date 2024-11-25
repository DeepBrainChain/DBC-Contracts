// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IMachineInfo {
    function getMachineCalcPoint(string memory machineId) external view returns (uint256 calcPoint);
    function getMachineCPURate(string memory machineId) external view returns (uint256);
    function getMachineGPUCount(string memory machineId) external view returns (uint8);
    function getOwnerRentEndAt(string memory machineId,uint256 rentId) external view returns (uint256);
    function isMachineOwner(string memory machineId,address evmAddress) external view returns (bool);
    function getDLCMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256);
    function getDBCMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256);
    function getUSDTMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256);
}