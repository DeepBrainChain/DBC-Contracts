// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ILogic {
    function getOwnerRentEndAt(string memory machineId,uint256 rentId) external view returns (uint256);
    function isMachineOwner(string memory machineId,address evmAddress) external view returns (bool);
}