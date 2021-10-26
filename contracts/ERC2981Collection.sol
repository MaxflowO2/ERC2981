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

abstract contract ERC2981Collection is IERC2981 {

  address private royaltyAddress;
  uint256 private royaltyPercent;

  // Set to be internal function _setRoyalties
  function _setRoyalties(address _receiver, uint256 _percentage) internal {
    royaltyAddress = _receiver;
    royaltyPercent = _percent;
  }

  // Override for royaltyInfo(uint256, uint256)
  function royaltyInfo(
    uint256 _tokenId,
    uint256 _salePrice
  ) external view override(IERC2981) returns (
    address receiver,
    uint256 royaltyAmount
  ) {
    receiver = royaltyAddress;

    // This sets percentages by price * percentage / 100
    royaltyAmount = _salePrice * royaltyPercent / 100;
  }
}
