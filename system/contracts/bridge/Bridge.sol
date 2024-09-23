// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.18;

import "./interfaces/IBridge.sol";

contract Bridge is IBridge {
    address private constant precompile = address(0x0000000000000000000000000000000000000800);

    function transfer(string memory to, uint256 amount) public virtual returns (bool) {
        require(bytes(to).length == 66, "The address is invalid. This address only supports public keys, and the length in hexadecimal is 66");

        (bool success, bytes memory returnData) = precompile.delegatecall(
            abi.encodeWithSignature(
                "transfer(string,uint256)",
                to,
                amount
            )
        );
        require(success, string(returnData));

        emit Transfer(msg.sender, to, amount);
        return true;
    }
}
