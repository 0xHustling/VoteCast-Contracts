// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { MessagingFee, Origin } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import { OAppCore } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppCore.sol";
import { MessagingReceipt } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";
import { OAppReceiver } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppReceiver.sol";

import { IEntryPoint } from "./interfaces/IEntryPoint.sol";

contract DestinationVoterOApp is OAppReceiver {
    address entryPoint;

    event VoteSuccessful();

    constructor(
        address _endpoint,
        address _delegate,
        address _entryPoint
    ) OAppCore(_endpoint, _delegate) Ownable(_delegate) {
        entryPoint = _entryPoint;
    }

    /**
     * @dev Internal function override to handle incoming messages from another chain.
     * @dev _origin A struct containing information about the message sender.
     * @dev _guid A unique global packet identifier for the message.
     * @param payload The encoded message payload being received.
     *
     * @dev The following params are unused in the current implementation of the OApp.
     * @dev _executor The address of the Executor responsible for processing the message.
     * @dev _extraData Arbitrary data appended by the Executor to the message.
     *
     * Decodes the received payload and processes it as per the business logic defined in the function.
     */
    function _lzReceive(
        Origin calldata /*_origin*/,
        bytes32 /*_guid*/,
        bytes calldata payload,
        address /*_executor*/,
        bytes calldata /*_extraData*/
    ) internal override {
        IEntryPoint.UserOperation memory userOp = abi.decode(payload, (IEntryPoint.UserOperation));
        IEntryPoint.UserOperation[] memory userOpArr = new IEntryPoint.UserOperation[](1);
        userOpArr[0] = userOp;
        IEntryPoint(entryPoint).handleOps(userOpArr, payable(userOp.sender));
        emit VoteSuccessful();
    }
}
