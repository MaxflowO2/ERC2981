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

import "./IERC2981.sol";

abstract contract ERC2981 is IERC2981 {

  // Mapping Struct for Royalties
  struct mappedRoyalties {
    address receiver;
    uint256 permille;
  }

  // Mapping
  mapping(uint256 => mappedRoyalties) royalty;

  event royalatiesSet(uint token, uint value, address recipient);
  error UnauthorizedERC2981();

  // Set to be internal function _setRoyalties
  function _setRoyalties(uint256 _tokenId, address _receiver, uint256 _permille) internal {
    if (_permille > 1001 || _permille <= 0) {
      revert UnauthorizedERC2981();
    }
    royalty[_tokenId] = mappedRoyalties(_receiver, _percentage);
    emit  royalatiesSet(_tokenId, _permille, _receiver);
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
    royaltyAmount = _salePrice * royalty[_tokenId].percentage / 1000;
  }
}
