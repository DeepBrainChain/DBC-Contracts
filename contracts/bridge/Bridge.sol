// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.18;

import "./interfaces/IBridge.sol";

contract Bridge is IBridge {
    address private constant PRECOMPILE =
        address(0x0000000000000000000000000000000000000800);

    function transfer(string memory to, uint256 amount) public virtual returns (bool) {
        (bool success, bytes memory returnData) = PRECOMPILE.delegatecall(
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
