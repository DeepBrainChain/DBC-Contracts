
## 枚举

### `StakingType`
```solidity
enum StakingType {
   ShortTerm,
   LongTerm,
   Free
}
```
**描述：** 定义可用的质押类型(从0开始)。

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
**描述：** 定义可以报告的通知类型(从0开始)。

## 函数

### 公共和外部函数

#### `report`
```solidity
function report(NotifyType tp, string calldata projectName, StakingType stakingType, string calldata machineId) external onlyAuthorizedReporters;
```
**描述：** 报告机器状态更新。