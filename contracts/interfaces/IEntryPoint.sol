// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.22;

interface IEntryPoint {
    /**
     * User Operation struct
     * @param sender                - The sender account of this request.
     * @param nonce                 - Unique value the sender uses to verify it is not a replay.
     * @param initCode              - If set, the account contract will be created by this constructor/
     * @param callData              - The method call to execute on this account.
     * @param accountGasLimits      - Packed gas limits for validateUserOp and gas limit passed to the callData method call.
     * @param preVerificationGas    - Gas not calculated by the handleOps method, but added to the gas paid.
     *                                Covers batch overhead.
     * @param gasFees               - packed gas fields maxPriorityFeePerGas and maxFeePerGas - Same as EIP-1559 gas parameters.
     * @param paymasterAndData      - If set, this field holds the paymaster address, verification gas limit, postOp gas limit and paymaster-specific extra data
     *                                The paymaster will pay for the transaction instead of the sender.
     * @param signature             - Sender-verified signature over the entire request, the EntryPoint address and the chain ID.
     */
    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    /**
     * Execute a batch of UserOperations.
     * No signature aggregator is used.
     * If any account requires an aggregator (that is, it returned an aggregator when
     * performing simulateValidation), then handleAggregatedOps() must be used instead.
     * @param ops         - The operations to execute.
     * @param beneficiary - The address to receive the fees.
     */
    function handleOps(UserOperation[] calldata ops, address payable beneficiary) external;
}
