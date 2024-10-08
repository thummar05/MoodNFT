# Mood NFT

## Overview

Mood NFT is an ERC721 smart contract that allows users to mint NFTs representing their moods. Each NFT can be in a happy or sad state, and the mood can be flipped by the owner. This project leverages Solidity, OpenZeppelin contracts, and the Base64 encoding utility to generate metadata for the NFTs.

## Features

- Mint NFTs with a default mood of SAD.
- Flip the mood of the NFT between HAPPY and SAD.
- Each NFT has a unique token ID.
- The metadata for each NFT is stored on-chain and includes a base64-encoded SVG image representation of the mood.

## Technologies Used

- **Solidity**: Smart contract programming language.
- **OpenZeppelin Contracts**: Provides standard implementations of ERC721 tokens.
- **Base64**: Used for encoding the NFT metadata.

## Getting Started

### Prerequisites

- Anvil Foundry installed
- MetaMask for managing Ethereum accounts

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/thummar05/MoodNFT.git
   cd MoodNFT
   
2. Set up the project:
    ```bash
   forge init
   
3. Compile the smart contract:
   ```bash
   forge build


### Usage
   Minting a Mood NFT: Call the mint() function to create a new Mood NFT. The initial mood will be set to SAD.

   Flipping Mood: Call the flipMood(uint256 tokenId) function to change the mood of your NFT.

   Token URI: The tokenURI(uint256 tokenId) function provides the metadata of the NFT, including the SVG image based on its mood.

### Contributing
   Feel free to open issues or submit pull requests to improve the Mood NFT project.
