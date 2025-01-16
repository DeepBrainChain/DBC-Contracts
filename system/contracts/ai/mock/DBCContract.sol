// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../interfaces/DBCStaking.sol";

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

contract DBCStakingContractMock is DBCStakingContract {
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
                string memory machineId
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
        }
}
