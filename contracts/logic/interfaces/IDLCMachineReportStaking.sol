// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
interface IDLCMachineReportStaking {
    function reportDlcStaking(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId) external returns (bool success);
    function reportDlcEndStaking(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId) external returns (bool success);
}
