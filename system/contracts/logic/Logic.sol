// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interfaces/IMachineInfo.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";


// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Logic is IMachineInfo,Initializable,UUPSUpgradeable,OwnableUpgradeable {

    address private constant machineInfoPrecompile = address(0x0000000000000000000000000000000000000803);

    function initialize() public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner  {}


    function getMachineCalcPoint(string memory machineId) public view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getMachineCalcPoint(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getMachineCPURate(string memory machineId) public view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getMachineCPURate(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getMachineGPUCount(string memory machineId) external view returns (uint8){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getMachineGPUCount(string)",
            machineId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint8));
    }

    // get machine rent end block number by owner
    function getOwnerRentEndAt(string memory machineId,uint256 rentId) external view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getRentEndAt(string,uint256)",
            machineId,
            rentId
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    // check if th evm address is the owner of the machine
    function isMachineOwner(string memory machineId,address evmAddress) external view returns (bool){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "isMachineOwner(string,address)",
            machineId,
            evmAddress
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (bool));
    }

    function getDLCMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDLCMachineRentFee(string,uint256,uint256)",
            machineId,
            rentBlocks,
            rentGpuCount
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256))*1000;
    }

    function getDBCMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getDBCMachineRentFee(string,uint256,uint256)",
            machineId,
            rentBlocks,
            rentGpuCount
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function getUSDTMachineRentFee(string memory machineId,uint256 rentBlocks,uint256 rentGpuCount) external view returns (uint256){
        (bool success, bytes memory returnData) = machineInfoPrecompile.staticcall(abi.encodeWithSignature(
            "getUSDTMachineRentFee(string,uint256,uint256)",
            machineId,
            rentBlocks,
            rentGpuCount
        ));
        require(success, string(returnData));
        return abi.decode(returnData, (uint256));
    }

    function version() external pure returns (uint256){
        return 1;
    }
}
