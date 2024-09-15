// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessagingFee, Origin} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";
import {MessagingReceipt, OAppSender} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";
import {OAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppCore.sol";

import {IEntryPoint} from "./interfaces/IEntryPoint.sol";

contract SourceVoterOApp is OAppSender {
    constructor(address _endpoint, address _delegate) OAppCore(_endpoint, _delegate) Ownable(_delegate) {}

    /**
     * @notice Sends a message from the source chain to a destination chain.
     * @param _dstEid The endpoint ID of the destination chain.
     * @param _userOperation The user operation for voting on the destinaion chain
     * @param _options Additional options for message execution.
     * @dev Encodes the message as bytes and sends it using the `_lzSend` internal function.
     * @return receipt A `MessagingReceipt` struct containing details of the message sent.
     */
    function castVote(uint32 _dstEid, IEntryPoint.UserOperation calldata _userOperation, bytes calldata _options)
        external
        payable
        returns (MessagingReceipt memory receipt)
    {
        bytes memory _payload = abi.encode(_userOperation);
        receipt = _lzSend(_dstEid, _payload, _options, MessagingFee(msg.value, 0), payable(msg.sender));
    }

    /**
     * @notice Quotes the gas needed to pay for the full omnichain transaction in native gas or ZRO token.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _userOperation The user operation for voting on the destinaion chain
     * @param _options Message execution options (e.g., for sending gas to destination).
     * @param _payInLzToken Whether to return fee in ZRO token.
     * @return fee A `MessagingFee` struct containing the calculated gas fee in either the native token or ZRO token.
     */
    function quote(
        uint32 _dstEid,
        IEntryPoint.UserOperation calldata _userOperation,
        bytes memory _options,
        bool _payInLzToken
    ) public view returns (MessagingFee memory fee) {
        bytes memory _payload = abi.encode(_userOperation);
        fee = _quote(_dstEid, _payload, _options, _payInLzToken);
    }
}
