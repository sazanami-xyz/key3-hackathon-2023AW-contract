// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Web3Mint is ERC721 {
    struct NftAttributes {
        string name;
        string imageURL;
        uint256 numberOfLike;
        string comment;
    }

    NftAttributes[] Web3Nfts;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("PIACERE", "piacere") {
        console.log("This is my NFT contract.");
    }

    function mintIpfsNFT(string memory name, string memory imageURI) public {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Web3Nfts.push(
            NftAttributes({
                name: name,
                imageURL: imageURI,
                numberOfLike: 0,
                comment: "It was a wonderful view!"
            })
        );
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        _tokenIds.increment();
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        Web3Nfts[_tokenId].name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "PIACERE sample NFT", "image": "ipfs://',
                        Web3Nfts[_tokenId].imageURL,
                        '"}'
                    )
                )
            )
        );
        return json;
    }

    function list() public view returns (string memory) {
        string memory str = '{"attribute":[';
        for (uint256 i = 0; i < Web3Nfts.length; i++) {
            string memory attribute = string(
                abi.encodePacked(
                    '{"name": "',
                    Web3Nfts[i].name,
                    " -- NFT #: ",
                    Strings.toString(i),
                    '", "description": "PIACERE sample NFT", "image": "https://',
                    Web3Nfts[i].imageURL,
                    ".ipfs.w3s.link/",
                    Strings.toString(i),
                    '.png", "like": "',
                    Strings.toString(Web3Nfts[i].numberOfLike),
                    '", "comment": "',
                    Web3Nfts[i].comment,
                    '"}'
                )
            );
            if (i != Web3Nfts.length - 1) {
                attribute = string(abi.encodePacked(attribute, ","));
            }
            str = string(abi.encodePacked(str, attribute));
        }
        str = string(abi.encodePacked(str, "]}"));
        string memory json = Base64.encode(bytes(str));
        return json;
    }

    function addLike(uint256 _tokenId) public returns (string memory) {
        uint256 likes = Web3Nfts[_tokenId].numberOfLike;
        Web3Nfts[_tokenId].numberOfLike = likes + 1;

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        Web3Nfts[_tokenId].name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "like": "',
                        Strings.toString(Web3Nfts[_tokenId].numberOfLike),
                        '"}'
                    )
                )
            )
        );
        return json;
    }
}
