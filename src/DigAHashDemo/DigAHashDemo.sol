// SPDX-License-Identifier: GNU GPLv3
/**
 * @title Dig-A-Hash Demo NFT Contract Version 0.0.1
 * @author KidSysco @ Dig-A-Hash
 * This contract contains properties, and functions for use with the Dig-A-Hash API.
 * https://www.dig-a-hash.com
 */

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DigAHashDemo is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, AccessControl, ERC721Burnable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    address private _contractOwnerAddress;
    string private _metaDataBasePath;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Dig-A-Hash Public Demo", "DIGADEMO") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _contractOwnerAddress = msg.sender;

        string memory baseURI = "https://nft.dah-services.com/profiles/";
        string memory walletContractUri = getWalletContractPath();
        _metaDataBasePath = string(abi.encodePacked(baseURI, walletContractUri));
    }

    function adminBurn(uint256 tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        super._burn(tokenId);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * Mint a new token using OZ _safeMint.
     * @param to - The address to mint the token to.
     */
    function mint(address to) public {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        // Generate the Dig-A-Hash token URI.
        string memory dahTokenURI = generateMetaDataURI(tokenId);
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, dahTokenURI);
    }

    /**
     * Generate a Dig-A-Hash meta-data URI based on the token id.
     * @param tokenId - the token id.
     */
    function generateMetaDataURI(uint256 tokenId) internal view returns (string memory) {
        string memory tokenIdStr = tokenId.toString();
        string memory extension = ".json";

        return string(abi.encodePacked(_metaDataBasePath, tokenIdStr, extension));
    }

    /**
     * Get the contract info for URI generation. {contractOwnerAddress}/meta-data/{chainid}/{contractAddress}/
     */
    function getWalletContractPath() internal view returns (string memory) {
        uint256 chainId = block.chainid;
        address contractAddress = address(this);
        string memory contractAddressStr = Strings.toHexString(uint256(uint160(contractAddress)), 20);
        string memory walletAddressStr = Strings.toHexString(uint256(uint160(_contractOwnerAddress)), 20);
        
        return string(abi.encodePacked(walletAddressStr, "/meta-data/", chainId.toString(), "/", contractAddressStr, "/"));
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
