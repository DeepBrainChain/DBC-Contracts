# AI Smart Contract Interface Documentation

## Overview
The **AI** smart contract is an upgradeable contract designed to manage project staking contracts and handle machine state reporting. It incorporates functionality for:

- Managing authorized reporters.
- Registering and updating machine states.
- Interfacing with staking contracts for various project types.
- Integrating with a DBC staking contract.

## Table of Contents

1. [Contract Initialization](#contract-initialization)
2. [Events](#events)
3. [Modifiers](#modifiers)
4. [State Variables](#state-variables)
5. [Functions](#functions)
    - [Public and External Functions](#public-and-external-functions)
    - [Internal Functions](#internal-functions)

---

## Contract Initialization

### `initialize`
```solidity
function initialize(address dbcContractAddr, address[] calldata _authorizedReporters) public initializer
```
**Description:** Initializes the contract, setting the DBC staking contract and authorized reporters.

**Parameters:**
- `dbcContractAddr`: Address of the DBC staking contract.
- `_authorizedReporters`: List of addresses to be authorized as reporters.

**Modifiers:**
- `initializer`

---

## Events

### `AuthorizedUpgrade`
```solidity
event AuthorizedUpgrade(address indexed canUpgradeAddress);
```
**Description:** Emitted when a new address is authorized to upgrade the contract.

### `AddAuthorizedReporter`
```solidity
event AddAuthorizedReporter(address indexed reporter);
```
**Description:** Emitted when a reporter is added.

### `RemoveAuthorizedReporter`
```solidity
event RemoveAuthorizedReporter(address indexed reporter);
```
**Description:** Emitted when a reporter is removed.

### `ContractRegister`
```solidity
event ContractRegister(address indexed caller, string projectName, address indexed stakingContractAddress);
```
**Description:** Emitted when a staking contract is registered for a project.

### `MachineStateUpdate`
```solidity
event MachineStateUpdate(string machineId, string projectName, StakingType stakingType, NotifyType tp);
```
**Description:** Emitted when a machine’s state is updated.

### `NotifiedTargetContract`
```solidity
event NotifiedTargetContract(address indexed targetContractAddress, NotifyType tp, string machineId, bool result);
```
**Description:** Emitted when a notification is sent to a target contract.

### `DBCContractChanged`
```solidity
event DBCContractChanged(address indexed dbcContractAddr);
```
**Description:** Emitted when the DBC contract address is updated.

---

## Modifiers

### `onlyAuthorizedReporters`
```solidity
modifier onlyAuthorizedReporters();
```
**Description:** Restricts access to functions to only authorized reporters.

---

## State Variables

### `dbcContract`
```solidity
DBCStakingContract public dbcContract;
```
**Description:** Stores the address of the DBC staking contract.

### `authorizedReporters`
```solidity
mapping(address => bool) public authorizedReporters;
```
**Description:** Maps addresses to their authorization status as reporters.

### `canUpgradeAddress`
```solidity
address public canUpgradeAddress;
```
**Description:** Stores the address authorized to upgrade the contract.

### `projectName2StakingContractAddress`
```solidity
mapping(string => mapping(StakingType => address)) public projectName2StakingContractAddress;
```
**Description:** Maps project names and staking types to their respective staking contract addresses.

### `machineInProject2States`
```solidity
mapping(string => MachineState) public machineInProject2States;
```
**Description:** Tracks the state of machines in projects.

---

## Functions

### Public and External Functions

#### `_authorizeUpgrade`
```solidity
function _authorizeUpgrade(address newImplementation) internal override;
```
**Description:** Authorizes an upgrade to a new implementation.

#### `requestSetUpgradePermission`
```solidity
function requestSetUpgradePermission(address _canUpgradeAddress) external pure returns (bytes memory);
```
**Description:** Generates the calldata for setting upgrade permission.

#### `setUpgradePermission`
```solidity
function setUpgradePermission(address _canUpgradeAddress) external onlyOwner;
```
**Description:** Sets the address authorized to upgrade the contract.

#### `addAuthorizedReporter`
```solidity
function addAuthorizedReporter(address reporter) external onlyOwner;
```
**Description:** Adds an authorized reporter.

#### `removeAuthorizedReporter`
```solidity
function removeAuthorizedReporter(address reporter) external onlyOwner;
```
**Description:** Removes an authorized reporter.

#### `setDBCContract`
```solidity
function setDBCContract(address dbcContractAddr) external onlyOwner;
```
**Description:** Updates the DBC staking contract address.

#### `registerProjectStakingContract`
```solidity
function registerProjectStakingContract(string calldata projectName, StakingType stakingType, address stakingContractAddress) external;
```
**Description:** Registers a staking contract for a project.

#### `report`
```solidity
function report(NotifyType tp, string calldata projectName, StakingType stakingType, string calldata machineId) external onlyAuthorizedReporters;
```
**Description:** Reports a machine state update.

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

### Internal Functions

#### `getKeyOfMachineInProject`
```solidity
function getKeyOfMachineInProject(string calldata machineId, string calldata projectName, StakingType stakingType) internal pure returns (string memory);
```
**Description:** Generates a unique key for a machine in a project.

#### `StakingTypeEnumToString`
```solidity
function StakingTypeEnumToString(StakingType stakingType) internal pure returns (string memory);
```
**Description:** Converts a `StakingType` enum to its string representation.

---

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

