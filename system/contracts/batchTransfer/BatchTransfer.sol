// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/interface.sol";

contract BatchTransfer is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    event ERC20BatchTransfer(
        address indexed sender,
        address indexed recipient,
        uint256 amount
    );
    event ERC721BatchTransfer(
        address indexed sender,
        address indexed recipient,
        uint256 indexed tokenId
    );

    event ERC721BatchMint(
        address indexed minter,
        address indexed recipient,
        uint16 level,
        uint256 amount
    );

    struct ERC20Transfer {
        address recipient;
        uint256 amount;
    }

    struct ERC721Transfer {
        address recipient;
        uint256 tokenId;
    }

    struct ERC721Mint {
        address recipient;
        uint16 level;
        uint256 amount;
    }

    /// @notice Initialize the contract, only callable once
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /**
     * @notice Batch transfer of ERC20 tokens using a struct array
     * @param token Address of the ERC20 contract
     * @param transfers List of recipient and amount pairs
     */
    function batchTransferERC20(
        address token,
        ERC20Transfer[] calldata transfers
    ) public {
        require(transfers.length > 0, "BatchTransfer: transfers array is empty");
        require(transfers.length <= 200, "BatchTransfer: too many transfers, max is 200");

        for (uint256 i = 0; i < transfers.length; i++) {
            IERC20(token).transferFrom(
                msg.sender,
                transfers[i].recipient,
                transfers[i].amount
            );
            emit ERC20BatchTransfer(
                msg.sender,
                transfers[i].recipient,
                transfers[i].amount
            );
        }
    }

    /**
     * @notice Batch transfer of ERC721 tokens using a struct array
     * @param token Address of the ERC721 contract
     * @param transfers List of recipient and tokenId pairs
     */
    function batchTransferERC721(
        address token,
        ERC721Transfer[] calldata transfers
    ) public {
        require(transfers.length > 0, "BatchTransfer: transfers array is empty");
        require(transfers.length <= 200, "BatchTransfer: too many transfers, max is 200");
        for (uint256 i = 0; i < transfers.length; i++) {
            IERC721(token).safeTransferFrom(
                msg.sender,
                transfers[i].recipient,
                transfers[i].tokenId
            );
            emit ERC721BatchTransfer(
                msg.sender,
                transfers[i].recipient,
                transfers[i].tokenId
            );
        }
    }

    function batchMintERC721(
        address token,
        uint256 totalAmount,
        ERC721Mint[] calldata mints
    ) internal {
        require(mints.length > 0, "BatchTransfer: mints array is empty");
        require(mints.length * totalAmount <= 500, "BatchTransfer: too many mints or totalAmount");

        for (uint256 i = 0; i < mints.length; i++) {
            IERC721WithBatchMint(token).safeBatchMint(
                mints[i].recipient,
                mints[i].level,
                mints[i].amount
            );

            totalAmount -= mints[i].amount;
            emit ERC721BatchMint(
                msg.sender,
                mints[i].recipient,
                mints[i].level,
                mints[i].amount
            );
        }

        require(totalAmount == 0, "BatchTransfer: total amount invalid");
    }


    /// @notice Authorize upgrades, restricted to contract owner
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function version() external pure returns(uint256) {
        return 0;
    }
}
