// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.18;

interface IPrice {
    function getDBCPrice() external view returns (uint256);
    function getDBCAmountByValue(uint256 amount) external view returns (uint256);
}
