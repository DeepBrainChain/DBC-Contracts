// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interfaces/IMachineInfo.sol";
import "./interfaces/IAIProjectRegister.sol";
import "./interfaces/IDLCMachineReportStaking.sol";
import "./interfaces/IDLCMachineSlashInfo.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Logic is IAIProjectRegister,IMachineInfo,IDLCMachineReportStaking,IDLCMachineSlashInfo,Initializable,OwnableUpgradeable {

    address private constant projectRegisterPrecompile = address(0x0000000000000000000000000000000000000802);
    address private constant machineInfoPrecompile = address(0x0000000000000000000000000000000000000803);
    address private constant dlcMachineReportStakingPrecompile = address(0x0000000000000000000000000000000000000804);
    address private constant dlcMachineSlashInfoPrecompile = address(0x0000000000000000000000000000000000000805);


    function initialize() public initializer {
        __Ownable_init();
    }


    function getMachineCalcPoint(string memory machineId) public view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getMachineCalcPoint(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getRentDuration(string memory msgToSign,string memory substrateSig,string memory substratePubKey,uint256 lastClaimAt, uint256 slashAt,string memory machineId) external view returns (uint256 rentDuration){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getRentDuration(string,string,string,uint256,uint256,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            lastClaimAt,
            slashAt,
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getDlcMachineRentDuration(uint256 lastClaimAt,uint256 slashAt, string memory machineId) external view returns (uint256 rentDuration){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDlcMachineRentDuration(uint256,uint256,string)",
            lastClaimAt,
            slashAt,
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function machineIsRegistered(string memory machineId,string memory projectName) public view returns (bool){
        (bool success, bytes memory returnData) = projectRegisterPrecompile.staticcall(abi.encodeWithSignature(
            "machineIsRegistered(string,string)",
            machineId,
            projectName
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }


    function addMachineRegisteredProject(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external returns(bool) {
        (bool success, bytes memory returnData) = projectRegisterPrecompile.call(abi.encodeWithSignature(
            "addMachineRegisteredProject(string,string,string,string,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            machineId,
            projectName
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function removalMachineRegisteredProject(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external returns(bool)  {
        (bool success, bytes memory returnData) = projectRegisterPrecompile.call(abi.encodeWithSignature(
            "removeMachineRegisteredProject(string,string,string,string,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            machineId,
            projectName
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function isRegisteredMachineOwner(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId,string memory projectName) external view returns (bool){
        (bool success, bytes memory returnData) = projectRegisterPrecompile.staticcall(abi.encodeWithSignature(
            "isRegisteredMachineOwner(string,string,string,string,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            machineId,
            projectName
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function reportDlcStaking(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId) external returns (bool){
        (bool success, bytes memory returnData) = dlcMachineReportStakingPrecompile.call(abi.encodeWithSignature(
            "reportDlcStaking(string,string,string,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function reportDlcEndStaking(string memory msgToSign,string memory substrateSig,string memory substratePubKey,string memory machineId) external returns (bool){
        (bool success, bytes memory returnData) = dlcMachineReportStakingPrecompile.call(abi.encodeWithSignature(
            "reportDlcEndStaking(string,string,string,string)",
            msgToSign,
            substrateSig,
            substratePubKey,
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function getDlcMachineSlashedAt(string memory machineId) external view returns (uint256){
        (bool success, bytes memory returnData) = dlcMachineSlashInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDlcMachineSlashedAt(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getDlcMachineSlashedReportId(string memory machineId) external view returns (uint256){
        (bool success, bytes memory returnData) = dlcMachineSlashInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDlcMachineSlashedReportId(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getDlcMachineSlashedReporter(string memory machineId) external view returns (address){
        (bool success, bytes memory returnData) = dlcMachineSlashInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDlcMachineSlashedReporter(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (address));
    }
}
