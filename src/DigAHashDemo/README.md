# Dig-A-Hash Demo NFT Contract Readme

## Description

The Dig-A-Hash Demo NFT Contract Version 0.0.1. This contract is designed to be used with the Dig-A-Hash platform at https://www.dig-a-hash.com.

This contract mints a fairly standard ERC721 token with most of the major features such as: minting, pausing, burning, transferring, and it includes automatic Meta-Data URI generation for use with the Dig-A-Hash Dynamic Meta-Data API.

This contract is a great starting point for those who want to mint their own General Purpose NFTs.

## Contracts in Use

This contract uses the following contracts:

- OpenZeppelin's ERC721.sol
- OpenZeppelin's ERC721Enumerable.sol
- OpenZeppelin's ERC721URIStorage.sol
- OpenZeppelin's Pausable.sol
- OpenZeppelin's AccessControl.sol
- OpenZeppelin's ERC721Burnable.sol
- Public Functions
- The following public functions are available in this contract:

# Public Functions

The following is a list of all public functions in the contract:

## constructor()

Constructor function, which sets the contract name, symbol, and initializes the contract owner address, and URI path for generating meta-data.

## adminBurn(uint256 tokenId)

Function to burn a token. This function can only be called by the contract owner.

## pause()

Function to pause the contract. This function can only be called by the contract owner.

## unpause()

Function to unpause the contract. This function can only be called by the contract owner.

## mint(address to)

Function to mint a new token. This function generates a Dig-A-Hash token URI and mints the token using OZ \_safeMint.

## tokenURI(uint256 tokenId)

Function to get the token URI for a given token. This function is overridden from the ERC721 and ERC721URIStorage standards.

## burn(uint256 tokenId)

Function to burn a token. This function is inherited from the ERC721Burnable extension. The token is destroyed and removed from the owner's account. This function can only be called by the owner of the token.

## transfer(address to, uint256 tokenId)

Function to transfer a token to a new owner. This function is inherited from the ERC721 standard. The token is transferred from the sender's account to the to address. This function can only be called by the owner of the token or an approved operator.

## approve(address to, uint256 tokenId)

Function to grant approval to a third-party operator to transfer a specific token on the owner's behalf. This function is inherited from the ERC721 standard. The to address specified in the function call must be a valid Ethereum address, and the tokenId specified must correspond to an existing token that the caller owns. Once approval is granted, the operator can transfer the token using the transferFrom() function.

## transferFrom(address from, address to, uint256 tokenId)

Function to transfer a specific token from one address to another. This function is inherited from the ERC721 standard. The from address specified in the function call must be the current owner of the token, or an approved operator that has been granted permission to transfer the token on the owner's behalf using the approve() function. The to address specified must be a valid Ethereum address. Once the transfer is complete, the ownership of the token is updated accordingly.

## balanceOf(address owner)

Function to get the number of tokens owned by a specific address. This function is inherited from the ERC721 and ERC721Enumerable standards. The owner address specified in the function call must be a valid Ethereum address. The function returns the number of tokens that the address owns.

## totalSupply()

Function to get the total number of tokens that exist in the contract. This function is inherited from the ERC721 and ERC721Enumerable standards. The function returns the total number of tokens that have been minted by the contract.

## tokenOfOwnerByIndex(address owner, uint256 index)

Function to get the token ID of a specific token owned by an address at a given index. This function is inherited from the ERC721 and ERC721Enumerable standards. The owner address specified in the function call must be a valid Ethereum address, and the index specified must be a valid index of the tokens owned by the address (i.e., it must be less than the value returned by balanceOf(owner)). The function returns the token ID of the token at the specified index.

# Internet Functions

The following is a list of internal functions added to the the contract to create the Dig-A-Hash Meta-Data URL based on the token ID, the contract address, the wallet address, and the chain ID.

## generateMetaDataURI(uint256 tokenId)

Function to generate a Dig-A-Hash meta-data URI based on the token id. This function is an internal function and can only be called by the contract. The function takes one argument: the tokenId of the token for which the URI is being generated. The function generates a URI that is a combination of the \_metaDataBasePath and the tokenId in the form of a JSON file.

## getWalletContractPath()

Function to get the contract info for URI generation. This function is an internal function and can only be called by the contract. The function retrieves the contract owner address, the contract address, and the current blockchain network ID, and generates a URL path that includes this information. The generated URL path is used as the base URI for all Dig-A-Hash tokens minted by the contract. The function returns a string with the generated URL path.

License
This contract is licensed under the GNU GPLv3 license.
