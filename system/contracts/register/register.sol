// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interfaces/IAIProjectRegister.sol";
import "./interfaces/ILogic.sol";


// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Register is IAIProjectRegister,Initializable,OwnableUpgradeable {
    uint8 public constant MAX_PROJECTS_PER_MACHINE = 3;

    ILogic public logicContract;

    mapping(string => string[]) public machineId2ProjectNames;
    // mapping(machineId => mapping(projectName => owner address))
    mapping(string => mapping(string => address)) public registerInfo2Owner;

    event ProjectAdded(address indexed owner, string machineId, string projectName);
    event ProjectRemoved(address indexed owner, string machineId, string projectName);

    function initialize(address _logicContract) public initializer {
        __Ownable_init();
        logicContract = ILogic(_logicContract);
    }

    function setPrecompileContract(address _logicContract) external onlyOwner {
        logicContract = ILogic(_logicContract);
    }

    function machineIsRegistered(string memory machineId,string memory projectName) public view returns (bool){
        string[] memory projects = machineId2ProjectNames[machineId];
        return containsProject(projects, projectName);
    }

    function addMachineRegisteredProject(uint256 rentId,string memory machineId,string memory projectName) external {
        require(logicContract.isMachineOwner(machineId,msg.sender),"not machine owner");
        require(logicContract.getOwnerRentEndAt(machineId,rentId)>block.number,"machine not rented by owner");
        string[] storage projects = machineId2ProjectNames[machineId];
        if (containsProject(projects, projectName)){
            return;
        }
        require(projects.length<MAX_PROJECTS_PER_MACHINE,"max projects per machine reached");
        projects.push(projectName);
        registerInfo2Owner[machineId][projectName] = msg.sender;
        emit ProjectAdded(msg.sender, machineId, projectName);
    }

    function removalMachineRegisteredProject(string memory machineId,string memory projectName) external  {
        require(logicContract.isMachineOwner(machineId,msg.sender),"not machine owner");
        string[] storage projects = machineId2ProjectNames[machineId];
        require(containsProject(projects, projectName),"project not registered");
        removeProject(projects, projectName);
        registerInfo2Owner[machineId][projectName] = address(0);
        emit ProjectRemoved(msg.sender, machineId, projectName);
    }

    function isRegisteredMachineOwner(string memory machineId,string memory projectName) external view returns (bool){
        return registerInfo2Owner[machineId][projectName] == msg.sender;
    }

    function containsProject(string[] memory projects, string memory projectName) internal pure returns (bool) {
        for(uint i=0 ; i < projects.length; i++){
            if(keccak256(bytes(projects[i])) == keccak256(bytes(projectName))){
                return true;
            }
        }
        return false;
    }

    function removeProject(string[] storage projects, string memory projectName) internal {
        for(uint i=0 ; i < projects.length; i++){
            if(keccak256(bytes(projects[i])) == keccak256(bytes(projectName))){
                projects[i] = projects[projects.length-1];
                projects.pop();
            }
        }
    }

    function version() external pure returns (uint8)  {
        return 2;
    }
}