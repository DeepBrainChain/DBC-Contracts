
## Interface
### AIStakingContract
```solidity
    interface AIStakingContract {
        function notify(NotifyType tp, string calldata id) external returns (bool);
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
**Description:** Registers a staking contract for a project. the staking contract which wants to register should implement the `AIStakingContract` interface(The id can be the machine id or the container id, which is consistent with the resource unit used during registration) to get notified when a machine state changes(online/offline/registered/unregistered).


#### `getMachineState`
```solidity
function getMachineState(string calldata machineId, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered);
```
**Description:** Get the status of the specified machine. The id can be the machine id or the container id, which is consistent with the resource unit used during registration.

#### `getMachineInfo`
```solidity
function getMachineInfo(string calldata machineId) external view returns (address machineOwner, uint256 calcPoint, uint256 cpuRate, string memory gpuType, uint256 gpuMem, string memory cpuType, uint256 gpuCount);
```
**Description:** Get detailed information about the specified machine. The id can be a machine id or a container id, which is consistent with the resource unit used during registration.

---