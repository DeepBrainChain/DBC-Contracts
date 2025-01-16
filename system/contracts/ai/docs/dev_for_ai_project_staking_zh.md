## 接口文档

### `AIStakingContract` 接口
```solidity
interface AIStakingContract {
    function notify(NotifyType tp, string calldata id) external returns (bool);
}
```

---

## 枚举类型

### `StakingType`
```solidity
enum StakingType {
   ShortTerm,
   LongTerm,
   Free
}
```
**描述：** 定义了可用的质押类型。

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
**描述：** 定义了可报告的通知类型。

---

## 函数

### 公共和外部函数

#### `registerProjectStakingContract`
```solidity
function registerProjectStakingContract(string calldata projectName, StakingType stakingType, address stakingContractAddress) external;
```
**描述：** 为一个项目注册质押合约。需要注册的质押合约必须实现 `AIStakingContract` 接口(id可以是机器id或者是容器id,与注册时使用的资源单位一致)，以便在机器状态变化（上线/下线/注册/取消注册）时接收通知。

---

#### `getMachineState`
```solidity
function getMachineState(string calldata id, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered);
```
**描述：** 获取指定机器的状态,id可以是机器id或者是容器id,与注册时使用的资源单位一致。

---

#### `getMachineInfo`
```solidity
function getMachineInfo(string calldata id) external view returns (address machineOwner, uint256 calcPoint, uint256 cpuRate, string memory gpuType, uint256 gpuMem, string memory cpuType, uint256 gpuCount);
```
**描述：** 获取有关指定机器的详细信息,id可以是机器id或者是容器id,与注册时使用的资源单位一致。

---

