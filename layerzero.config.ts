import { MainnetV2EndpointId } from '@layerzerolabs/lz-definitions'

const baseContract = {
    eid: MainnetV2EndpointId.BASE_V2_MAINNET,
    // contractName: 'SourceVoterOApp',
    address: '0xCeeF0be32E21205b14a9ABa2A23A54248556D3a7',
}

const arbitrumContract = {
    eid: MainnetV2EndpointId.ARBITRUM_V2_MAINNET,
    // contractName: 'DestinationVoterOApp',
    address: '0xCeeF0be32E21205b14a9ABa2A23A54248556D3a7',
}

export default {
    contracts: [
        {
            contract: baseContract,
        },
        {
            contract: arbitrumContract,
        },
    ],
    connections: [
        {
            from: baseContract,
            to: arbitrumContract,
            config: {
                sendConfig: {
                    executorConfig: {
                        maxMessageSize: 99,
                        executor: '0x0000000000000000000000000000000000000000',
                    },
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: [
                            '0x9e059a54699a285714207b43B055483E78FAac25',
                            '0x8ddF05F9A5c488b4973897E278B58895bF87Cb24',
                        ],
                        optionalDVNs: [],
                        optionalDVNThreshold: 0,
                    },
                },
                receiveConfig: {
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: [
                            '0x9e059a54699a285714207b43B055483E78FAac25',
                            '0x8ddF05F9A5c488b4973897E278B58895bF87Cb24',
                        ],
                        optionalDVNs: [],
                        optionalDVNThreshold: 0,
                    },
                },
            },
        },
    ],
}
