// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../AI.sol";

contract AIStakingContractMock is AIStakingContract {
    mapping(string => bool) private machineNotificationStatus;

    function notify(AI.NotifyType tp, string calldata machineId) external override returns (bool) {
        machineNotificationStatus[machineId] = true;

        if (tp == AI.NotifyType.MachineOffline) {
            machineNotificationStatus[machineId] = false;
        }

        return true;
    }

}