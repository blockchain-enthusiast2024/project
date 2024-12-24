function verifyERC20Balance(
        address l2tokenAddress,
        uint256 nonce,
        uint256 balance,
        bytes32 storageRoot,
        bytes32 codeHash,
        bytes32 stateRoot, // This is obtained in L2OutputOracle
        bytes[] memory proof,
        address user,
        uint256 tokenBalance,
        bytes[] memory storageProof
    ) public pure returns (bool) {
        //Account value on the state trie is composed of the following components RLP encoded
        bytes[] memory input = new bytes[](4);
        input[0] = RLPWriter.writeUint(nonce);
        input[1] = RLPWriter.writeUint(balance);
        input[2] = RLPWriter.writeBytes(abi.encode(storageRoot));
        input[3] = RLPWriter.writeBytes(abi.encode(codeHash));
        bytes memory value = RLPWriter.writeList(input);
        //Verify the Account balance, nonce, storageRoot, codeHash are correct given the stateRoot
        require(SecureMerkleTrie.verifyInclusionProof(abi.encodePacked(l2tokenAddress), value, proof, stateRoot));

        //Now we can use the storageRoot to verify the balance of a given address
        //We obtain the storage key following https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html#mappings-and-dynamic-arrays
        bytes32 storageKey = keccak256(
            abi.encode(
                bytes32(uint256(uint160(user))),
                uint256(0) // The balances mapping is at the first slot in the layout.
            )
        );
        //Verify the balance for the user address is correct
        require(
            SecureMerkleTrie.verifyInclusionProof(
                abi.encodePacked(storageKey), RLPWriter.writeUint(tokenBalance), storageProof, storageRoot
            )
        );
        return true;
    }
