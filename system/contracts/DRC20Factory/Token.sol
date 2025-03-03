// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20,IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";




contract Token is ERC20, ERC20Permit,ERC20Burnable, Ownable {

    using SafeERC20 for IERC20;

    bool public isLockActive;

    struct LockInfo {
        uint256 lockedAt;
        uint256 lockedAmount;
        uint256 unlockAt;
    }

    mapping(address => LockInfo[]) private walletLockTimestamp;
    mapping(address => bool) public lockTransferAdmins;

    event LockDisabled(uint256 timestamp, uint256 blockNumber);
    event LockEnabled(uint256 timestamp, uint256 blockNumber);
    event TransferAndLock(address indexed from, address indexed to, uint256 value, uint256 blockNumber);
    event UpdateLockDuration(address indexed wallet, uint256 lockSeconds);
    event AddLockTransferAdmin(address indexed addr);
    event RemoveLockTransferAdmin(address indexed addr);

    modifier onlyLockTransferAdminOrOwner() {
        require(lockTransferAdmins[msg.sender] || msg.sender == owner(), "Not lock transfer admin");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address initialOwner, string memory name, string memory symbol,uint256 supply) ERC20(name, symbol) ERC20Permit(name) Ownable(){
        _mint(initialOwner, supply);
        isLockActive = true;

        _transferOwnership(initialOwner);
    }

    function disableLockPermanently() external onlyOwner {
        isLockActive = false;
        emit LockDisabled(block.timestamp, block.number);
    }

    function requestEnableLockPermanently() external pure returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("enableLockPermanently()");
        return data;
    }

    function enableLockPermanently() external onlyOwner {
        isLockActive = true;
        emit LockEnabled(block.timestamp, block.number);
    }

    function requestUpdateLockDuration(address wallet, uint256 lockSeconds) external pure returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("updateLockDuration(address,uint256)", wallet, lockSeconds);
        return data;
    }

    function updateLockDuration(address wallet, uint256 lockSeconds) external onlyOwner{
        LockInfo[] storage lockInfos = walletLockTimestamp[wallet];
        for (uint256 i = 0; i < lockInfos.length; i++) {
            lockInfos[i].unlockAt = lockInfos[i].lockedAt + lockSeconds;
        }
        emit UpdateLockDuration(wallet, lockSeconds);
    }

    function transferAndLock(address to, uint256 value, uint256 lockSeconds) external onlyLockTransferAdminOrOwner {
        require(lockSeconds > 0, "Invalid lock duration");
        uint256 lockedAt = block.timestamp;
        uint256 unLockAt = lockedAt + lockSeconds;

        LockInfo[] storage infos = walletLockTimestamp[to];
        require(infos.length < 100, "Too many lock entries"); // Limit lock entries

        infos.push(LockInfo(lockedAt, value, unLockAt));
        transfer(to, value);

        emit TransferAndLock(msg.sender, to, value, block.number);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        if (to == address(0) || amount == 0) {
            return super.transfer(to, amount);
        }

        if (isLockActive && walletLockTimestamp[msg.sender].length > 0) {
            require(canTransferAmount(msg.sender, amount), "Insufficient unlocked balance");
        }

        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        if (to == address(0) || amount == 0) {
            return super.transferFrom(from, to, amount);
        }

        if (isLockActive && walletLockTimestamp[from].length > 0) {
            require(canTransferAmount(from, amount), "Insufficient unlocked balance");
        }

        return super.transferFrom(from, to, amount);
    }

    function canTransferAmount(address from, uint256 transferAmount) internal view returns (bool) {
        uint256 lockedAmount = calculateLockedAmount(from);
        uint256 availableAmount = balanceOf(from) - lockedAmount;
        return availableAmount >= transferAmount;
    }

    function calculateLockedAmount(address from) public view returns (uint256) {
        LockInfo[] storage lockInfos = walletLockTimestamp[from];
        uint256 lockedAmount = 0;

        for (uint256 i = 0; i < lockInfos.length; i++) {
            if (block.timestamp < lockInfos[i].unlockAt) {
                lockedAmount += lockInfos[i].lockedAmount;
            }
        }

        return lockedAmount;
    }

    function getAvailableAmount(address caller) public view returns (uint256, uint256) {
        uint256 lockedAmount = calculateLockedAmount(caller);
        uint256 total = balanceOf(caller);
        uint256 availableAmount = total - lockedAmount;
        return (total, availableAmount);
    }

    function getLockAmountAndUnlockAt(address caller, uint16 index) public view returns (uint256, uint256) {
        require(index < walletLockTimestamp[caller].length, "Index out of range");
        LockInfo memory lockInfo = walletLockTimestamp[caller][index];
        return (lockInfo.lockedAmount, lockInfo.unlockAt);
    }

    function getLockInfos(address caller) public view returns (LockInfo[] memory) {
        LockInfo[] memory lockInfos = walletLockTimestamp[caller];
        return lockInfos;
    }

    function requestAddLockTransferAdmin(address addr) external pure returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("addLockTransferAdmin(address)", addr);
        return data;
    }

    function requestRemoveLockTransferAdmin(address addr) external pure returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("removeLockTransferAdmin(address)", addr);
        return data;
    }

    function addLockTransferAdmin(address addr) external onlyOwner {
        lockTransferAdmins[addr] = true;
        emit AddLockTransferAdmin(addr);
    }

    function removeLockTransferAdmin(address addr) external onlyOwner {
        lockTransferAdmins[addr] = false;
        emit RemoveLockTransferAdmin(addr);
    }
}
