# Dig-A-Hash Public Contracts

[![built-with openzeppelin](https://img.shields.io/badge/built%20with-OpenZeppelin-3677FF)](https://docs.openzeppelin.com/)

These are Solidity demo contracts in use by Dig-A-Hash to demonstrate the use of our platform. These contracts can be used as a starting point for your own projects.

These contracts are derived from the fully audited OpenZeppelin contracts.

## Files

Each contract has it's own folder and there are two files in each folder: the .sol file and the .sol_flattened file.

The .sol file is the original contract and the .sol_flattened file is the flattened version of the contract.

The flattened version is the same as the original contract but all the imports have been flattened into the file. This is useful for compiling the contract in it's raw form.

Connect with us at https://www.dig-a-hash.com for more information.

## Customizing the Contracts

Create a copy of the contract you want to customize and rename the file. Use camel-casing for the file name and then change the contract name to match the file name. DigAHashDemo can be changed to any name you wish in the contract declaration.

```
contract DigAHashDemo is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable,
```

Next, change the contract human readable name and the contract symbol for the needs of your project. The first param of the constructor is the name of the contract and the second param is the symbol. You can use spacing in the name but not in the symbol.

```
constructor() ERC721("Dig-A-Hash Public Demo", "DIGADEMO") {
```

The base URL must remain in order to use Dig-A-Hash's NFT Meta-Data services. Contact us for custom domains.

```
string memory baseURI = "https://nft.dah-services.com/profiles/";
```

## Compiling and Deploying

Remix and HardHat can both be used to compile the contracts for any EVM compatible blockchain.

We have also tested deployment with these contracts in [HardHat](https://github.com/NomicFoundation/hardhat) and [Remix](https://remix.ethereum.org/).

## OpenZeppelin Docs

See the following documentation for more information on the OpenZeppelin contracts, and how to use them in Hardhat, Remix, and Truffle.

https://docs.openzeppelin.com/

https://docs.openzeppelin.com/contracts/4.x/
