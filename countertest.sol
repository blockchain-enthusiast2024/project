// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TestTrie} from "../src/TestTrie.sol";

contract CounterTest is Test {
    TestTrie public trie;

    function setUp() public {
        trie = new TestTrie();
    }

    function test_Trie() public {
        string[4] memory t = [
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED"
        ];
        bytes[] memory t1 = new bytes[](4);
        t1[0] = bytes(t[0]);
        t1[1] = bytes(t[1]);
        t1[2] = bytes(t[2]);
        t1[3] = bytes(t[3]);
        trie.verifyAccountState(
            REDACTED,
            0x3d,
            0x016c7dd87dc49224,
            REDACTED,
            REDACTED,
            REDACTED,
            t1
        );
    }

    function test_trieERC20() public {
        string[4] memory t = [
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED"
        ];
        bytes[] memory t1 = new bytes[](4);
        t1[0] = bytes(t[0]);
        t1[1] = bytes(t[1]);
        t1[2] = bytes(t[2]);
        t1[3] = bytes(t[3]);

        string[2] memory stoargePro = [
            hex"REDACTED",
            hex"REDACTED"
        ];
        bytes[] memory storageProof = new bytes[](2);
        storageProof[0] = bytes(stoargePro[0]);
        storageProof[1] = bytes(stoargePro[1]);

        trie.verifyERC20Balance(
            REDACTED,
            1,
            0,
            0xeb56231f6963d4ab7e7959043c95731f6de46db304cffe8fd145ecb500ca8c33,
            0x971fcb2eacbd8cdf4b33947a9104a3f25f21334ff82e1ed21aba2276ac21e0ca,
            0xfd38068cee28844e9cc3194ba02659eca7f0812340e66d5602cd3970b6949925,
            t1,
            0xc6c976894f1DEeb72cB891135DDA011C2a853101,
            0x5f5e100,
            storageProof
        );
    }

    function test_ERC721() public {
        string[4] memory t = [
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED"
        ];
        bytes[] memory t1 = new bytes[](4);
        t1[0] = bytes(t[0]);
        t1[1] = bytes(t[1]);
        t1[2] = bytes(t[2]);
        t1[3] = bytes(t[3]);

        string[3] memory stoargePro = [
            hex"REDACTED",
            hex"REDACTED",
            hex"REDACTED"
        ];
        bytes[] memory storageProof = new bytes[](3);
        storageProof[0] = bytes(stoargePro[0]);
        storageProof[1] = bytes(stoargePro[1]);
        storageProof[2] = bytes(stoargePro[2]);

        trie.verifyERC721Balance(
            REDACTED,
            1,
            0,
            REDACTED,
            REDACTED,
            REDACTED,
            t1,
            REDACTED,
            0,
            storageProof
        );
    }
}