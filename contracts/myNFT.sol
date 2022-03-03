// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract myNFT is ERC721, ERC721Enumerable, Ownable {

    using SafeMath for uint256;
    uint public constant maxPurchase = 10;
    uint256 public constant MAX_NFTS = 10000;

    uint256 private _nftPrice = 1 ether;
    string private baseURI;
    bool public saleIsActive = true;

    constructor() ERC721("my NFT", "MNFT") {
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

		function withdraw() public onlyOwner {
			uint256 balance = address(this).balance;
			payable(msg.sender).transfer(balance);
		}    

    function setPrice(uint256 _newPrice) public onlyOwner() {
        _nftPrice = _newPrice;
    }

    function getPrice() public view returns (uint256){
        return _nftPrice;
    }

    function mintNFTs(uint numberOfTokens) public payable {
        require(saleIsActive, "Sale must be active to mint NFTs");
        require(numberOfTokens <= maxPurchase, "Can only mint 10 tokens at a time");
        require(totalSupply().add(numberOfTokens) <= MAX_NFTS, "Purchase would exceed max supply of NFTs");
        require(_nftPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_NFTS) {
                _safeMint(msg.sender, mintIndex);
            }
        }
    }      

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }  
}