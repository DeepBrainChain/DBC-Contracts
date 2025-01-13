# AI 智能合约接口文档

## 概述
**AI** 智能合约是一个可升级的合约，设计用于管理项目质押合约并处理机器状态的报告。其功能包括：

- 管理授权的报告者。
- 注册和更新机器状态。
- 与各种项目类型的质押合约交互。
- 集成 DBC 质押合约。

## 目录

1. [合约初始化](#合约初始化)
2. [事件](#事件)
3. [修饰符](#修饰符)
4. [状态变量](#状态变量)
5. [函数](#函数)
    - [公共和外部函数](#公共和外部函数)
    - [内部函数](#内部函数)

---

## 合约初始化

### `initialize`
```solidity
function initialize(address dbcContractAddr, address[] calldata _authorizedReporters) public initializer
```
**描述：** 初始化合约，设置 DBC 质押合约和授权的报告者。

**参数：**
- `dbcContractAddr`: DBC 质押合约的地址。
- `_authorizedReporters`: 授权报告者地址的列表。

**修饰符：**
- `initializer`

---

## 事件

### `AuthorizedUpgrade`
```solidity
event AuthorizedUpgrade(address indexed canUpgradeAddress);
```
**描述：** 当新地址被授权升级合约时触发。

### `AddAuthorizedReporter`
```solidity
event AddAuthorizedReporter(address indexed reporter);
```
**描述：** 当添加报告者时触发。

### `RemoveAuthorizedReporter`
```solidity
event RemoveAuthorizedReporter(address indexed reporter);
```
**描述：** 当移除报告者时触发。

### `ContractRegister`
```solidity
event ContractRegister(address indexed caller, string projectName, address indexed stakingContractAddress);
```
**描述：** 当为项目注册质押合约时触发。

### `MachineStateUpdate`
```solidity
event MachineStateUpdate(string machineId, string projectName, StakingType stakingType, NotifyType tp);
```
**描述：** 当机器状态更新时触发。

### `NotifiedTargetContract`
```solidity
event NotifiedTargetContract(address indexed targetContractAddress, NotifyType tp, string machineId, bool result);
```
**描述：** 当向目标合约发送通知时触发。

### `DBCContractChanged`
```solidity
event DBCContractChanged(address indexed dbcContractAddr);
```
**描述：** 当 DBC 合约地址更新时触发。

---

## 修饰符

### `onlyAuthorizedReporters`
```solidity
modifier onlyAuthorizedReporters();
```
**描述：** 限制仅授权报告者可以调用的函数。

---

## 状态变量

### `dbcContract`
```solidity
DBCStakingContract public dbcContract;
```
**描述：** 存储 DBC 质押合约的地址。

### `authorizedReporters`
```solidity
mapping(address => bool) public authorizedReporters;
```
**描述：** 映射地址到其授权状态。

### `canUpgradeAddress`
```solidity
address public canUpgradeAddress;
```
**描述：** 存储被授权升级合约的地址。

### `projectName2StakingContractAddress`
```solidity
mapping(string => mapping(StakingType => address)) public projectName2StakingContractAddress;
```
**描述：** 映射项目名称和质押类型到对应的质押合约地址。

### `machineInProject2States`
```solidity
mapping(string => MachineState) public machineInProject2States;
```
**描述：** 跟踪项目中机器的状态。

---

## 函数

### 公共和外部函数

#### `_authorizeUpgrade`
```solidity
function _authorizeUpgrade(address newImplementation) internal override;
```
**描述：** 授权升级到新实现。

#### `requestSetUpgradePermission`
```solidity
function requestSetUpgradePermission(address _canUpgradeAddress) external pure returns (bytes memory);
```
**描述：** 生成用于设置升级权限的 calldata。

#### `setUpgradePermission`
```solidity
function setUpgradePermission(address _canUpgradeAddress) external onlyOwner;
```
**描述：** 设置被授权升级合约的地址。

#### `addAuthorizedReporter`
```solidity
function addAuthorizedReporter(address reporter) external onlyOwner;
```
**描述：** 添加授权报告者。

#### `removeAuthorizedReporter`
```solidity
function removeAuthorizedReporter(address reporter) external onlyOwner;
```
**描述：** 移除授权报告者。

#### `setDBCContract`
```solidity
function setDBCContract(address dbcContractAddr) external onlyOwner;
```
**描述：** 更新 DBC 质押合约地址。

#### `registerProjectStakingContract`
```solidity
function registerProjectStakingContract(string calldata projectName, StakingType stakingType, address stakingContractAddress) external;
```
**描述：** 为项目注册质押合约。

#### `report`
```solidity
function report(NotifyType tp, string calldata projectName, StakingType stakingType, string calldata machineId) external onlyAuthorizedReporters;
```
**描述：** 报告机器状态更新。

#### `getMachineState`
```solidity
function getMachineState(string calldata machineId, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered);
```
**描述：** 获取机器的状态。

#### `getMachineInfo`
```solidity
function getMachineInfo(string calldata machineId) external view returns (address machineOwner, uint256 calcPoint, uint256 cpuRate, string memory gpuType, uint256 gpuMem, string memory cpuType, uint256 gpuCount);
```
**描述：** 获取机器的详细信息。

---

### 内部函数

#### `getKeyOfMachineInProject`
```solidity
function getKeyOfMachineInProject(string calldata machineId, string calldata projectName, StakingType stakingType) internal pure returns (string memory);
```
**描述：** 生成项目中机器的唯一键。

#### `StakingTypeEnumToString`
```solidity
function StakingTypeEnumToString(StakingType stakingType) internal pure returns (string memory);
```
**描述：** 将 `StakingType` 枚举转换为字符串表示。

---

## 枚举

### `StakingType`
```solidity
enum StakingType {
   ShortTerm,
   LongTerm,
   Free
}
```
**描述：** 定义可用的质押类型。

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
**描述：** 定义可以报告的通知类型。

---

