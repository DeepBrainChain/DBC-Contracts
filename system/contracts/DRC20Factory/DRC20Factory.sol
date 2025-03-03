// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Token.sol";

contract DRC20Factory {
    event DRC20TokenDeployed(address indexed tokenAddress);
    constructor() {}

    function deployDRC20Token(address _owner, string memory _name, string memory _symbol, uint256 supply) external {
        Token token = new Token(_owner,_name, _symbol, supply);
        emit DRC20TokenDeployed(address(token));
    }
}