// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IDLCMachineSlashInfo {
    function getDlcMachineSlashedAt(string memory machineId) external view returns (uint256 slashAt);
    function getDlcMachineSlashedReportId(string memory machineId) external view returns (uint256 reportId);
    function getDlcMachineSlashedReporter(string memory machineId) external view returns (address reporter);
    function isSlashed(string memory machineId) external view returns (bool slashed);
}