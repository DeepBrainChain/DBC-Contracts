
## Interface
### AIStakingContract
```solidity
    interface AIStakingContract {
        function notify(NotifyType tp, string calldata machineId) external returns (bool);
    }
```

## Enumerations

### `StakingType`
```solidity
enum StakingType {
   ShortTerm,
   LongTerm,
   Free
}
```
**Description:** Defines the types of staking available.

### `NotifyType`
```solidity
enum NotifyType {
   ContractRegister,
   MachineRegister,
   MachineUnregister,
   MachineOnline,
   MachineOffline
}
```
**Description:** Defines the types of notifications that can be reported.
---
## Functions

### Public and External Functions

#### `registerProjectStakingContract`
```solidity
function registerProjectStakingContract(string calldata projectName, StakingType stakingType, address stakingContractAddress) external;
```
**Description:** Registers a staking contract for a project. the staking contract which wants to register should implement the `AIStakingContract` interface to get notified when a machine state changes(online/offline/registered/unregistered).


#### `getMachineState`
```solidity
function getMachineState(string calldata machineId, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered);
```
**Description:** Retrieves the state of a machine.

#### `getMachineInfo`
```solidity
function getMachineInfo(string calldata machineId) external view returns (address machineOwner, uint256 calcPoint, uint256 cpuRate, string memory gpuType, uint256 gpuMem, string memory cpuType, uint256 gpuCount);
```
**Description:** Retrieves detailed information about a machine.

---