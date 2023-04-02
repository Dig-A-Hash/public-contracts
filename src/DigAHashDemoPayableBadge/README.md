# Dig-A-Hash Demo Payable Badge Contract Readme

## Description

Dig-A-Hash Demo Payable Badge Contract Version 0.0.1. This contract is designed to be used with the Dig-A-Hash platform at https://www.dig-a-hash.com.

This contract mints a soulbound badge token, based on the standard ERC721 token with some of the major features such as: minting, and pausing, but functions like burning, admin burning, and transferring have been disabled.

This contract requires a payment (payable) of 0.5 to mint a token, which is changeable after deployment. Contract owners can also withdraw the funds from the contract at any time.

This contract also includes automatic Meta-Data URI generation, and other features for use with the Dig-A-Hash Dynamic Meta-Data API.

This contract is a great starting point for those who are looking to create souldbound badges that cannot be transferred or burned. These are useful for identifying wallets to users, and token-gating.

## Contracts in Use

This contract uses the following contracts:

- OpenZeppelin's ERC721.sol
- OpenZeppelin's ERC721Enumerable.sol
- OpenZeppelin's ERC721URIStorage.sol
- OpenZeppelin's Pausable.sol
- OpenZeppelin's AccessControl.sol

## Access Control

The AccessControl contract used in these NFT contracts provides a built-in role-based access control mechanism, which allows us to specify which functions can be called by which roles. There are three roles defined: DEFAULT_ADMIN_ROLE, PAUSER_ROLE, and MINTER_ROLE.

The DEFAULT_ADMIN_ROLE is the top-level role and has the power to grant and revoke roles from other addresses. The PAUSER_ROLE can pause and unpause the contract to prevent certain functions from being called in case of an emergency, while the MINTER_ROLE can only mint new tokens. These roles ensure that only authorized parties can perform critical functions in the contract, providing an added layer of security and control.

# Public Functions

The following is a list of all public functions in the contract:

## constructor()

Constructor function, which sets the contract name, symbol, and initializes the contract owner address, and URI path for generating meta-data. The contract name and symbol values should be changed to suit your needs.

## pause()

Function to pause the contract from minting, transferring, and burning. This function can only be called by the contract owner.

## unpause()

Function to unpause the contract. This function can only be called by the contract owner.

## mint(address to)

Function to mint a new token. This function generates a Dig-A-Hash token URI and mints the token using OZ safeMint technique.

## tokenURI(uint256 tokenId)

Function to get the token URI for a given token. This function is overridden from the ERC721 and ERC721URIStorage standards. This link should point to a Dig-A-Hash Dynamic Meta-Data API endpoint, and the link is automatically built by the contract at mint. You do not need to worry about setting the Meta-Data URI.

## getMintFee()

This function is a public view function that returns the current value of the MINT_FEE variable. It takes no arguments and returns a uint256 value representing the fee required to mint a new token in wei.

## setMintFee(uint256 newMintFee)

This function is a public function that sets the value of the MINT_FEE variable to the value specified in the newMintFee argument. It requires the caller to have the DEFAULT_ADMIN_ROLE role. Once the MINT_FEE is set, it cannot be changed by anyone other than the contract owner.

## withdraw()

This function is a public function that allows the contract owner to withdraw the accumulated ether balance of the contract. It requires the caller to have the DEFAULT_ADMIN_ROLE role. Once the contract owner initiates this function, the ether balance will be transferred to the owner's address.

## balanceOf(address owner)

Function to get the number of tokens owned by a specific address. This function is inherited from the ERC721 and ERC721Enumerable standards. The owner address specified in the function call must be a valid Ethereum address. The function returns the number of tokens that the address owns.

## totalSupply()

Function to get the total number of tokens that exist in the contract. This function is inherited from the ERC721 and ERC721Enumerable standards. The function returns the total number of tokens that have been minted by the contract.

## tokenOfOwnerByIndex(address owner, uint256 index)

Function to get the token ID of a specific token owned by an address at a given index. This function is inherited from the ERC721 and ERC721Enumerable standards. The owner address specified in the function call must be a valid Ethereum address, and the index specified must be a valid index of the tokens owned by the address (i.e., it must be less than the value returned by balanceOf(owner)). The function returns the token ID of the token at the specified index.

# Internal Functions

The following is a list of internal functions added to the the contract to create the Dig-A-Hash Meta-Data URL based on the token ID, the contract address, the wallet address, and the chain ID.

## generateMetaDataURI(uint256 tokenId)

Function to generate a Dig-A-Hash meta-data URI based on the token id. This function is an internal function and can only be called by the contract. The function takes one argument: the tokenId of the token for which the URI is being generated. The function generates a URI that is a combination of the \_metaDataBasePath and the tokenId in the form of a JSON file.

## getWalletContractPath()

Function to get the contract info for URI generation. This function is an internal function and can only be called by the contract. The function retrieves the contract owner address, the contract address, and the current blockchain network ID, and generates a URL path that includes this information. The generated URL path is used as the base URI for all Dig-A-Hash tokens minted by the contract. The function returns a string with the generated URL path.

License
This contract is licensed under the GNU GPLv3 license.
