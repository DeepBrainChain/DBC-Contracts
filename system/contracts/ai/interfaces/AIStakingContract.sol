// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../AI.sol";

interface AIStakingContract {
    function notify(AI.NotifyType tp,string calldata machineId) external returns (bool);
}