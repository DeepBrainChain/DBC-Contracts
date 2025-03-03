// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./interfaces/AIStakingContract.sol";
import "./interfaces/DBCStaking.sol";
import "./interfaces/MachineInfo.sol";

contract AI is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    DBCStakingContract public dbcContract;
    MachineInfoContract public machineInfoContract;
    mapping(address => bool) public authorizedReporters;

    address public canUpgradeAddress;

    struct RegisterInfo {
        address toBeNotifiedMachineStateUpdateContractAddress;
        address toReportStakingStatusContractAddress;
    }

    mapping(string => mapping(StakingType => RegisterInfo)) public projectName2StakingContractAddress;

    enum StakingType {
       ShortTerm,
       LongTerm,
       Free
    }

    enum NotifyType {
        ContractRegister,
        MachineRegister,
        MachineUnregister,
        MachineOnline,
        MachineOffline
    }

    struct MachineState {
        bool isOnline;
        bool isRegistered;
        uint256 updateAtTimestamp;
    }

    // machineId-projectName-stakingType => MachineState
    mapping (string => MachineState) public machineInProject2States;

    event AuthorizedUpgrade(address indexed canUpgradeAddress);
    event AddAuthorizedReporter(address indexed reporter);
    event RemoveAuthorizedReporter(address indexed reporter);
    event ContractRegister(address indexed caller, string projectName, address indexed toBeNotifiedMachineStateUpdateContractAddress,address indexed toReportStakingStatusContractAddress);
    event MachineStateUpdate(string machineId, string projectName, StakingType stakingType, NotifyType tp);
    event NotifiedTargetContract(address indexed targetContractAddress, NotifyType tp, string machineId, bool result);
    event DBCContractChanged(address indexed dbcContractAddr);
    event MachineInfoContractChanged(address indexed addr);
    event ReportFailed(NotifyType tp, string projectName, StakingType stakingType, string machineId, string reason);
    event reportedStakingStatus(string projectName, StakingType tp, string machineId, uint256 gpuNum, bool isStake);

/// @notice Initialize the contract, only callable once
    function initialize(address machineInfoContractAddr, address dbcContractAddr, address[] calldata _authorizedReporters) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();

        machineInfoContract = MachineInfoContract(machineInfoContractAddr);
        dbcContract = DBCStakingContract(dbcContractAddr);
        for (uint i = 0; i < _authorizedReporters.length; i++) {
            require(_authorizedReporters[i]!= address(0), "Invalid address");
            authorizedReporters[_authorizedReporters[i]] = true;
        }
        canUpgradeAddress = msg.sender;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    modifier onlyAuthorizedReporters() {
        require(authorizedReporters[msg.sender], "Only authorized reporters can call this function");
        _;
    }

    function _authorizeUpgrade(address newImplementation) internal view override  {
        require(newImplementation!= address(0), "Invalid address");
        require(msg.sender == canUpgradeAddress, "Only authorized address can upgrade");
    }

    function requestSetUpgradePermission(address _canUpgradeAddress) external pure returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("setUpgradePermission(address)",_canUpgradeAddress);
        return data;
    }

    function setUpgradePermission(address _canUpgradeAddress) external onlyOwner {
        require(_canUpgradeAddress!= address(0), "Invalid address");
        canUpgradeAddress = _canUpgradeAddress;
        emit AuthorizedUpgrade(_canUpgradeAddress);
    }

    function addAuthorizedReporter(address reporter) external onlyOwner{
        require(reporter!= address(0), "Invalid address");
        require(!authorizedReporters[reporter], "Reporter already authorized");
        authorizedReporters[reporter] = true;
        emit AddAuthorizedReporter(reporter);
    }

    function removeAuthorizedReporter(address reporter) external onlyOwner {
        require(reporter!= address(0), "Invalid address");
        require(authorizedReporters[reporter], "Reporter not authorized");
        authorizedReporters[reporter] = false;
        emit RemoveAuthorizedReporter(reporter);
    }

    function setDBCContract(address dbcContractAddr) external onlyOwner {
        dbcContract = DBCStakingContract(dbcContractAddr);
        emit DBCContractChanged(dbcContractAddr);
    }

    function setMachineInfoContract(address addr) external onlyOwner {
        machineInfoContract = MachineInfoContract(addr);
        emit MachineInfoContractChanged(addr);
    }

    function registerProjectStakingContract(string calldata projectName, StakingType stakingType, address toBeNotifiedMachineStateUpdateContractAddress, address toReportStakingStatusContractAddress) external {
        require(toBeNotifiedMachineStateUpdateContractAddress != address(0), "Invalid toBeNotifiedMachineStateUpdateContractAddress");
        require(toReportStakingStatusContractAddress != address(0), "Invalid toReportStakingStatusContractAddress");

        require(projectName2StakingContractAddress[projectName][stakingType].toBeNotifiedMachineStateUpdateContractAddress == address(0), "Project already registered");
        require(AIStakingContract(toBeNotifiedMachineStateUpdateContractAddress).notify(NotifyType.ContractRegister,""));
        projectName2StakingContractAddress[projectName][stakingType] = RegisterInfo({
            toBeNotifiedMachineStateUpdateContractAddress: toBeNotifiedMachineStateUpdateContractAddress,
            toReportStakingStatusContractAddress: toReportStakingStatusContractAddress
        });
        emit ContractRegister(msg.sender, projectName, toBeNotifiedMachineStateUpdateContractAddress, toReportStakingStatusContractAddress);
    }

    function deleteRegisteredProjectStakingContract(string calldata projectName, StakingType stakingType) external onlyOwner {
        delete projectName2StakingContractAddress[projectName][stakingType];
    }

    function report(NotifyType tp, string calldata projectName, StakingType stakingType, string calldata machineId) external onlyAuthorizedReporters {
        require(tp == NotifyType.MachineRegister || tp == NotifyType.MachineUnregister || tp == NotifyType.MachineOnline || tp == NotifyType.MachineOffline, "Invalid notify type");
        address targetContractAddress = projectName2StakingContractAddress[projectName][stakingType].toBeNotifiedMachineStateUpdateContractAddress;
        if (targetContractAddress == address(0)){
            emit ReportFailed(tp, projectName, stakingType, machineId, "Project not registered");
            return;
        }

        string memory key = getKeyOfMachineInProject(machineId, projectName, stakingType);
        if (tp == NotifyType.MachineRegister){
            machineInProject2States[key].isRegistered = true;
        }else if (tp == NotifyType.MachineUnregister){
            machineInProject2States[key].isRegistered = false;
        }else if (tp == NotifyType.MachineOnline){
            machineInProject2States[key].isOnline = true;
        }else if (tp == NotifyType.MachineOffline){
            machineInProject2States[key].isOnline = false;
        }

        emit MachineStateUpdate(machineId, projectName, stakingType, tp);

        AIStakingContract targetContract = AIStakingContract(targetContractAddress);
        bool result = targetContract.notify(tp, machineId);
        emit NotifiedTargetContract(targetContractAddress,tp, machineId,result);
    }

    function getMachineState(string calldata machineId, string calldata projectName, StakingType stakingType) external view returns (bool isOnline, bool isRegistered) {
        string memory key = getKeyOfMachineInProject(machineId, projectName, stakingType);
        return (machineInProject2States[key].isOnline, machineInProject2States[key].isRegistered);
    }

    function getMachineInfo(string calldata id, bool isDeepLink) external view returns (address machineOwner,uint256 calcPoint,uint256 cpuRate,string memory gpuType, uint256 gpuMem,string memory cpuType, uint256 gpuCount, string memory machineId,uint256 mem){
        (machineOwner,calcPoint,cpuRate,gpuType, gpuMem,cpuType,gpuCount, machineId,,,mem) =  machineInfoContract.getMachineInfo(id, isDeepLink);
        return (machineOwner,calcPoint,cpuRate,gpuType, gpuMem,cpuType,gpuCount, machineId,mem);
    }

    function getKeyOfMachineInProject(string calldata machineId, string calldata projectName, StakingType stakingType) internal pure returns(string memory) {
        return string(abi.encodePacked(machineId, "-",projectName,"-", StakingTypeEnumToString(stakingType)));

    }

    function StakingTypeEnumToString(StakingType stakingType) internal pure returns(string memory) {
            if (stakingType == StakingType.ShortTerm) {
                return "ShortTerm";
            } else if (stakingType == StakingType.LongTerm) {
                return "LongTerm";
            } else if (stakingType == StakingType.Free) {
                return "Free";
            } else {
                return "Unknown";
            }
    }

    function reportStakingStatus(string calldata projectName, StakingType stakingType, string calldata id, uint256 gpuNum, bool isStake) external {
        address targetContractAddress = projectName2StakingContractAddress[projectName][stakingType].toReportStakingStatusContractAddress;
        require(msg.sender == targetContractAddress, "Only registered staking contract can call this function");
        dbcContract.reportStakingStatus(id, gpuNum, isStake);
        emit reportedStakingStatus(projectName, stakingType, id, gpuNum, isStake);
    }

    function freeGpuAmount(string calldata _id) external view returns (uint256){
        return dbcContract.freeGpuAmount(_id);
    }

    function getMachineRegion(string calldata _id) public view returns(string memory){
        return machineInfoContract.getMachineRegion(_id);
    }

}