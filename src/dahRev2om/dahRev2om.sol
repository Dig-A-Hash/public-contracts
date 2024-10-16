// SPDX-License-Identifier: MIT
// Dig-A-Hash ERC721 Smart Contract Revision 2 - Owner Mint
// Only the contract owner can mint or batch mint.
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract dahRev2om is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, AccessControl, ERC721Burnable {
    using Strings for uint256;

    address private _contractOwnerAddress;
    string private _metaDataBasePath;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;

    constructor()
        ERC721("Dig-A-Hash Rev 2 Owner Mint", "DahRev2om")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
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

    // Simple access control using require
    function mintBatch(address to, uint256 numberOfTokens) external {
        require(hasRole(MINTER_ROLE, msg.sender), "Only minters can mint");
        require(numberOfTokens > 0, "Number of tokens must be greater than 0");

        for (uint256 i = 0; i < numberOfTokens; i++) {
           _mintToken(to);
        }
    }

    /**
     * Mint a new token using OZ _safeMint.
     * @param to - The address to mint the token to.
     */
    function mint(address to) public {
      require(hasRole(MINTER_ROLE, msg.sender), "Only minters can mint");
      _mintToken(to);
    }

    /**
     * An internal mint function used by mint and mintBatch
     * @param to - The address to mint the token to.
     */
    function _mintToken(address to) internal {
      uint256 tokenId = _nextTokenId++;

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

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
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
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
