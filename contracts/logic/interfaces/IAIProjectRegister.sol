// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IAIProjectRegister {
    function machineIsRegistered(string memory machineId,string memory projectName) external view returns (bool isRegistered);
    function addMachineRegisteredProject(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external returns (bool success);
    function RemovalMachineRegisteredProject(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external returns (bool success);
    function IsRegisteredMachineOwner(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external view returns (bool isOwner);
}

