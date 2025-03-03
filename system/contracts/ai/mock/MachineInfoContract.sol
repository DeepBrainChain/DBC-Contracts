// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MachineInfoContract} from "../interfaces/MachineInfo.sol";

        struct MachineInfo {
        address machineOwner;
        uint256 calcPoint;
        uint256 cpuRate;
        string gpuType;
        uint256 gpuMem;
        string cpuType;
        uint256 gpuCount;
        string machineId;
}

contract MachineInfoContractMock is MachineInfoContract {
        mapping(string => MachineInfo) private machineInfoStore;

        constructor() {
                machineInfoStore["machine1"] = MachineInfo({
                        machineOwner: address(0x01),  // machineOwner
                        calcPoint: 1000,  // calcPoint
                        cpuRate: 80,      // cpuRate
                        gpuType: "NVIDIA",  // gpuType
                        gpuMem: 16,       // gpuMem
                        cpuType: "Intel",  // cpuType
                        gpuCount: 1, // gpuCount
                        machineId: "machine1"
                });
        }

        function getMachineInfo(string calldata id,bool _isDeepLink) external view override returns (
                address machineOwner,
                uint256 calcPoint,
                uint256 cpuRate,
                string memory gpuType,
                uint256 gpuMem,
                string memory cpuType,
                uint256 gpuCount,
                string memory machineId,
                string memory ignore1,
                string memory ignore2,
                uint256 ignore3
        ) {
                _isDeepLink = true;
                MachineInfo storage machine = machineInfoStore[id];

                machineOwner = machine.machineOwner;
                calcPoint = machine.calcPoint;
                cpuRate = machine.cpuRate;
                gpuType = machine.gpuType;
                gpuMem = machine.gpuMem;
                cpuType = machine.cpuType;
                gpuCount = machine.gpuCount;
                machineId = machine.machineId;
                ignore1 = "";
                ignore2 = "";
                ignore3 = 0;
        }

        function getMachineRegion(string calldata) public pure returns(string memory){
                return "Asia";
        }

}
