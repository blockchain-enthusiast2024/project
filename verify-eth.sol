function verifyAccountState(
        address user,
        uint256 nonce,
        uint256 balance,
        bytes32 storageRoot,
        bytes32 codeHash,
        bytes32 stateRoot, // This is obtained in L2OutputOracle
        bytes[] memory proof
    ) public pure returns (bool) {
        //Account value on the state trie is composed of the following components RLP encoded
        bytes[] memory input = new bytes[](4);
        input[0] = RLPWriter.writeUint(nonce);
        input[1] = RLPWriter.writeUint(balance);
        input[2] = RLPWriter.writeBytes(abi.encode(storageRoot));
        input[3] = RLPWriter.writeBytes(abi.encode(codeHash));
        bytes memory value = RLPWriter.writeList(input);

        //Verify the Account balance, nonce, storageRoot, codeHash are correct given the stateRoot
        require(SecureMerkleTrie.verifyInclusionProof(abi.encodePacked(user), value, proof, stateRoot));
        return true;
    }