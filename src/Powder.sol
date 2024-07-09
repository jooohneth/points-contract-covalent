// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract Powder is Ownable {
  bytes32 public merkleRoot;

  mapping(address => bool) public claimed;
  mapping(address => uint256) public points;

  event Claimed(address indexed claimer, uint256 pointsClaimed);
  event NewRoot(bytes32 root);

  constructor(bytes32 _merkleRoot) Ownable(msg.sender) {
      merkleRoot = _merkleRoot;
  }

  function modifyRoot(bytes32 _merkleRoot) onlyOwner external {
    merkleRoot = _merkleRoot;
    emit NewRoot(_merkleRoot);
  }

  function claim(bytes32[] memory proof, address account) public {
    require(!claimed[account], "Points already claimed!");

    bytes32 leaf = keccak256(abi.encodePacked(account));
    require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof!");
    
    points[account] += 100 ether;
    claimed[account] = true;

    emit Claimed(account, 100 ether);
  }
}






