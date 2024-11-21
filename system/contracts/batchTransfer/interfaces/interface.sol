// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
interface IERC721WithBatchMint is IERC721{
    function safeBatchMint(address to, uint16 level, uint256 amount) external;
}