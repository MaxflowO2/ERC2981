/***
 *    ███████╗██████╗  ██████╗██████╗  █████╗  █████╗  ██╗
 *    ██╔════╝██╔══██╗██╔════╝╚════██╗██╔══██╗██╔══██╗███║
 *    █████╗  ██████╔╝██║      █████╔╝╚██████║╚█████╔╝╚██║
 *    ██╔══╝  ██╔══██╗██║     ██╔═══╝  ╚═══██║██╔══██╗ ██║
 *    ███████╗██║  ██║╚██████╗███████╗ █████╔╝╚█████╔╝ ██║
 *    ╚══════╝╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚════╝  ╚════╝  ╚═╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./interface/IERC2981.sol";

abstract contract ERC2981 is IERC2981 {

  // ERC165
  // royaltyInfo(uint256,uint256) => 0x2a55205a
  // ERC2981 => 0x2a55205a

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
  // royaltyInfo(uint256,uint256) => 0x2a55205a
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
