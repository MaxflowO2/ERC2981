/***
 *    ███████╗██████╗  ██████╗██████╗  █████╗  █████╗  ██╗
 *    ██╔════╝██╔══██╗██╔════╝╚════██╗██╔══██╗██╔══██╗███║
 *    █████╗  ██████╔╝██║      █████╔╝╚██████║╚█████╔╝╚██║
 *    ██╔══╝  ██╔══██╗██║     ██╔═══╝  ╚═══██║██╔══██╗ ██║
 *    ███████╗██║  ██║╚██████╗███████╗ █████╔╝╚█████╔╝ ██║
 *    ╚══════╝╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚════╝  ╚════╝  ╚═╝
 * Written by MaxflowO2
 * You can follow along at https://github.com/MaxflowO2/ERC2981
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./IERC2981.sol";

abstract contract ERC2981 is IERC2981 {

  // Mapping Struct for Royalties
  struct mappedRoyalties {
    address receiver;
    uint256 percentage;
  }

  // Mapping
  mapping(uint256 => mappedRoyalties) royalty;

  // Set to be internal function _setRoyalties
  function _setRoyalties(uint256 _tokenId, address _receiver, uint256 _percentage) internal {
    royalty[_tokenId] = mappedRoyalties(_receiver, _percentage);
  }

  // Override for royaltyInfo(uint256, uint256)
  function royaltyInfo(
    uint256 _tokenId,
    uint256 _salePrice
  ) external view override(IERC2981) returns (
    address receiver,
    uint256 royaltyAmount
  ) {
    receiver = royalty[_tokenId].receiver;

    // This sets percentages by price * percentage / 100
    royaltyAmount = _salePrice * royalty[_tokenId].percentage / 100;
  }
}
