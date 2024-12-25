// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.18;

interface IBridge {
    event Transfer(address indexed from, string to, uint256 amount);

    function transfer(string memory to, uint256 amount) external returns (bool);
}
