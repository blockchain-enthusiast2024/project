const l1provider = new ethers.providers.JsonRpcProvider("https://ethereum-sepolia-rpc.publicnode.com");
const L2OutputOracleAddress = "REDACTED";
const L2OutputOracleContract = new ethers.Contract(L2OutputOracleAddress, L2OutputOracle.abi, l1provider);

//Get the last output Root that was published to L1
const latestOutputIndex = await L2OutputOracleContract.latestOutputIndex();
const latestOutput = await L2OutputOracleContract.getL2Output(latestOutputIndex);

//Insert the target ERC20 token address that we want to prove balance
const l2Token = "REDACTED";

//For ERC20 key is obtained by keccak256(abi.encode(bytes32(uint256(uint160(user))),uint256(balance mapping slot)))
const key = "0xdb1a38445904fb8caaa212a47b0d0d776880120256ab9622e70e5524e8b97b5c";
//Local node started with the database from S3
const l2provider = new ethers.providers.JsonRpcProvider("http://localhost:38545");

//Get block hash and stateRoot from the last block that was published on L1
const { stateRoot, hash } = await l2provider.send('eth_getBlockByNumber', ["0x" + Number(latestOutput.l2BlockNumber).toString(16), false]);

//Get the state proof that includes the ERC20 state and storage
const proof = await l2provider.send('eth_getProof', [
  l2Token,
  [key],
  "0x" + Number(latestOutput.l2BlockNumber).toString(16)
]);

//Verify Proof locally;
const stateTrie = new Trie({ root: Buffer.from(stateRoot.slice(2), "hex"), useKeyHashing: true });
await stateTrie.updateFromProof(proof.accountProof.map((p: string) => Buffer.from(p.slice(2), "hex")));
const val = await stateTrie.get(Buffer.from(l2Token.slice(2), "hex"), true);
//Shows information about  nonce, balance, storageRoot ,and codeHash respectevly 
console.log(ethers.utils.RLP.decode(val!));

//Use StorageRoot to prove balance
const storageTrie = new Trie({ root: Buffer.from(proof.storageHash.slice(2), "hex"), useKeyHashing: true });
await storageTrie.updateFromProof(proof.storageProof[0].proof.map((p: string) => Buffer.from(p.slice(2), "hex")));
const val2 = await storageTrie.get(Buffer.from(key.slice(2), "hex"), true);
//Shows token balance
console.log(ethers.utils.RLP.decode(val2!));