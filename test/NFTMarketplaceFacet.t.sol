// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "contracts/facets/ERC721Facet.sol";
import "contracts/facets/NFTMarketplaceFacet.sol";
import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/Diamond.sol";
import "./helpers/DiamondUtils.sol";

import "test/helpers/HelperFunc.sol";

contract NftMarketPlaceTest is Helpers {
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    ERC721Facet ercFacet;
    NFTMarketplaceFacet public nftmarket;

    struct Order {
        address owner;
        address tokenAddress;
        uint tokenId;
        uint nftPrice;
        uint deadline;
        bytes signature;
        bool active;
    }

    address accountA;
    address accountB;

    uint256 privKeyA;
    uint256 privKeyB;

    NFTMarketplace.Order o;

    event NFTLISTED(uint orderId);
    event NFTSOLD(uint orderId);

    uint _deadline = block.timestamp + 3601;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(
            address(this),
            address(dCutFacet),
            "Joe NFT",
            "JOE"
        );
        dLoupe = new DiamondLoupeFacet();
        ercFacet = new ERC721Facet();
        ownerF = new OwnershipFacet();
        nftmarket = new NFTMarketplace();

        (accountA, privKeyA) = mkaddr("USERA");
        (accountB, privKeyB) = mkaddr("USERB");

        o = NFTMarketplace.Order({
            seller: address(0),
            tokenAddress: address(nft),
            tokenId: 1,
            price: 2 ether,
            active: false,
            signature: bytes(""),
            deadline: 0
        });
        ercFacet.mintNFT(accountA, 1);
    }

    //  function testOwnerCannotCreateOrder() public {
    //         o.seller = addr2;
    //         switchSigner(addr2);

    //         vm.expectRevert("Only token owner can create a listing");
    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.signature,
    //             o.deadline
    //         );
    //     }

    //     function testApproveContract() public {
    //         switchSigner(addr1);
    //         vm.expectRevert("Token owner must approve this contract");
    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.signature,
    //             o.deadline
    //         );
    //     }

    //     function testPrice() public {
    //         switchSigner(addr1);
    //         nft.setApprovalForAll(address(nftMarketPlace), true);
    //         vm.expectRevert("Price must be greater than 0");

    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             0,
    //             o.signature,
    //             o.deadline
    //         );
    //     }

    //     function testDeadline() public {
    //         switchSigner(addr1);
    //         nft.setApprovalForAll(address(nftMarketPlace), true);
    //         vm.expectRevert("Invalid deadline");

    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.signature,
    //             0
    //         );
    //     }

    //     function testCorrectSignature() public {
    //         switchSigner(addr1);
    //         nft.setApprovalForAll(address(nftMarketPlace), true);
    //         o.deadline = uint88(block.timestamp + 150 minutes);
    //         o.signature = constructSig(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.deadline,
    //             msg.sender,
    //             privKeyA
    //         );

    //         vm.expectRevert("Invalid signature");
    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.signature,
    //             o.deadline
    //         );
    //     }

    //     function testListingId() public {
    //         switchSigner(addr1);
    //         vm.expectRevert("Invalid listing ID");
    //         nftMarketPlace.executeOrder(1);
    //     }

    //     function testActiveOrder() public {
    //         testCorrectSignature();
    //         vm.expectRevert("Order is not active");
    //         nftMarketPlace.executeOrder(0);
    //     }

    //     function testingCorrectOrderPrice() public {
    //         testCorrectSignature();
    //         vm.expectRevert("Transaction value does not match order price");

    //         nftMarketPlace.executeOrder{value: o.price}(0);
    //     }

    //     function testingzExpiredOrder() public {
    //         switchSigner(addr1);
    //         nft.setApprovalForAll(address(nftMarketPlace), true);
    //         o.deadline = uint88(block.timestamp + 150 minutes);
    //         o.signature = constructSig(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.deadline,
    //             msg.sender,
    //             privKeyA
    //         );
    //         nftMarketPlace.createOrder(
    //             o.tokenAddress,
    //             o.tokenId,
    //             o.price,
    //             o.signature,
    //             o.deadline
    //         );

    //         vm.expectRevert("Order has expired");

    //         nftMarketPlace.executeOrder{value: o.price}(0);
    //     }
}
