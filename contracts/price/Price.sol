// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.18;

import "./interfaces/IPrice.sol";

contract Price is IPrice {
    address private constant precompile = address(0x0000000000000000000000000000000000000801);

    function getDBCPrice() public view override returns (uint256) {
        (bool success, bytes memory returnData) = precompile.staticcall(
            abi.encodeWithSignature(
                "getDBCPrice"
            )
        );
        require(success, string(returnData));

        return abi.decode(returnData, (uint256));
    }

    function getDBCAmountByValue(uint256 value) public view override returns (uint256) {
        require(value > 0, "invalid value");

        (bool success, bytes memory returnData) = precompile.staticcall(
            abi.encodeWithSignature(
                "getDBCAmountByValue(uint256)",
                value
            )
        );
        require(success, string(returnData));

        return abi.decode(returnData, (uint256));
    }
}
