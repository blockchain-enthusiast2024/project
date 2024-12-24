// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { CrossDomainMessenger } from "../universal/CrossDomainMessenger.sol";
import { IERC20Resolver } from "./IERC20Resolver.sol";
import { IERC721Resolver } from "./IERC721Resolver.sol";

/// @title ResolverRegistry
/// @notice Contract to register Resolver contracts that will produce the storage slot corresponding to an user
/// ERC20token balance, or ownership of an ERC721 token. Also includes default resolver implemetations for contracts
/// that did not register resolvers.
contract ResolverRegistry is IERC20Resolver, IERC721Resolver {
    mapping(address => address) public resolvers;

    CrossDomainMessenger immutable messenger;

    constructor(address _messenger) {
        messenger = CrossDomainMessenger(_messenger);
    }

    /// @notice Function to register resolver contracts.
    /// @dev This function can only be used by performing a cross chain call from L2 cross domain messenger.
    /// @param _resolver Adress of the resolver contract.
    function setResolver(address _resolver) external {
        require(msg.sender == address(messenger));
        address sender = messenger.xDomainMessageSender();
        resolvers[sender] = _resolver;
    }

    /// @notice Default resolver to get the storage slot of an user ERC20 balance.
    /// @param _user Address of the user to get the balance.
    function getERC20Slot(address _user) external pure returns (bytes32) {
        return keccak256(abi.encode(uint256(uint160(_user)), uint256(0)));
    }

    /// @notice Default resolver to get the storage slot of an ERC721 token owner.
    /// @param _tokenId TokenId to check the owner.
    function getERC721Slot(uint256 _tokenId) external pure returns (bytes32) {
        return keccak256(abi.encode(_tokenId, uint256(2)));
    }
}
