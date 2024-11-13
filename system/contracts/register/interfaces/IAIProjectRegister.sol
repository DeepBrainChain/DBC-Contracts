// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IAIProjectRegister {
    function machineIsRegistered(string memory machineId,string memory projectName) external view returns (bool isRegistered);
    function addMachineRegisteredProject(uint256 rentId,string memory machineId,string memory projectName) external;
    function removalMachineRegisteredProject(string memory machineId,string memory projectName) external;
    function isRegisteredMachineOwner(string memory machineId,string memory projectName) external view returns (bool isOwner);
}