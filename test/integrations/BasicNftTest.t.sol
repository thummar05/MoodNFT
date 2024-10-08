// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant ChefSimba =
        "https://ipfs.io/ipfs/bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = new BasicNft();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Chef Simba";
        string memory actualName = basicNft.name();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(ChefSimba);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(ChefSimba)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
