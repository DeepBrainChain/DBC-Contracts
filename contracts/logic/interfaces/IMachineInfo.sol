// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IMachineInfo {
    function getMachineCalcPoint(string memory machineId) external view returns (uint256 calcPoint);
    function getRentDuration(string memory msgToSign,string memory substrateSig,string memory substratePubKey,uint256 lastClaimAt,uint256 slashAt, string memory machineId) external view returns (uint256 rentDuration);
}