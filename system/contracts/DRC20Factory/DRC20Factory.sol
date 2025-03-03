// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Token.sol";

contract DRC20Factory {
    constructor() {}

    function deployDRC20Token(address _owner, string memory _name, string memory _symbol, uint256 supply) public returns (address) {
        Token token = new Token(_owner,_name, _symbol, supply);
        return address(token);
    }
}