// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import   "../interfaces/DBCStaking.sol";

contract DBCStakingContractMock is DBCStakingContract {
    function freeGpuAmount(string calldata) external pure returns (uint256){
        return 1;
    }
}