//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFTCollection is ERC721 {
    uint256 token_count;

    constructor() ERC721("My NFT", "MYNFT") {}

    function mintNFT(address to) public
    {
        _mint(to, token_count);
        token_count  += 1;
    }
}