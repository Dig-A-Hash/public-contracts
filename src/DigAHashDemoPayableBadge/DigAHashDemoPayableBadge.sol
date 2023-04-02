// SPDX-License-Identifier: GNU GPLv3
/**
 * @title Dig-A-Hash Payable Badge Demo NFT Contract Version 0.0.1
 * @author KidSysco @ Dig-A-Hash
 * This contract is a replica of the Dig-A-Hash Demo NFT Contract, but with the addition of a payable mint function, and the NFTs in this contract are not transferable.
 * https://www.dig-a-hash.com
 */

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
// Non-transferable = non-burnable, removed from inheritance.
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DigAHashDemoPayableBadge is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, AccessControl {
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256 private MINT_FEE = 5e16; // 0.05 ETH

    address private _contractOwnerAddress;
    string private _metaDataBasePath;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Dig-A-Hash Payable Badge Demo", "DIGADEMOPB") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _contractOwnerAddress = msg.sender;

        string memory baseURI = "https://nft.dah-services.com/profiles/";
        string memory walletContractUri = getWalletContractPath();
        _metaDataBasePath = string(abi.encodePacked(baseURI, walletContractUri));
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function getMintFee() public view returns (uint256) {
        return MINT_FEE;
    }

    /**
     * Sets the mint fee for the contract.
     */
    function setMintFee(uint256 newMintFee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        MINT_FEE = newMintFee;
    }

    /**
     * Mint a new token using OZ _safeMint.
     * @param to - The address to mint the token to.
     */
    function mint(address to) public payable {
        require(msg.value == MINT_FEE, "SoulboundBadge: Mint fee not met");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        // Generate the Dig-A-Hash token URI.
        string memory dahTokenURI = generateMetaDataURI(tokenId);
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, dahTokenURI);
    }

    /**
     * Withdraw collected funds to the contract owner's address.
     */
    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE) {
        payable(_contractOwnerAddress).transfer(address(this).balance);
    }

    /**
     * Override the OZ transfer function to disable transfers.
     */
    function _transfer(
        address /*from*/,
        address /*to*/,
        uint256 /*tokenId*/
    ) internal pure override {
        revert("SoulboundBadge: Transfers are disabled");
    }

    /**
     * Override the OZ safeTransfer function to disable transfers.
     */
    function safeTransferFrom(
    address /*from*/,
    address /*to*/,
    uint256 /*tokenId*/
    ) public pure override(ERC721, IERC721) {
        revert("SoulboundBadge: Transfers are disabled");
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

    /**
     * Override the OZ _burn function to disable burning.
     */
    function _burn(uint256 /* tokenId */) internal pure override(ERC721, ERC721URIStorage) {
        revert("SoulboundBadge: Burning is disabled");
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
