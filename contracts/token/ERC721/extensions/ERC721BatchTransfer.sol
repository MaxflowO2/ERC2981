/***
 *    ██████╗  █████╗ ████████╗ ██████╗██╗  ██╗                          
 *    ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║                          
 *    ██████╔╝███████║   ██║   ██║     ███████║                          
 *    ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║                          
 *    ██████╔╝██║  ██║   ██║   ╚██████╗██║  ██║                          
 *    ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝                          
 *                                                                       
 *    ████████╗██████╗  █████╗ ███╗   ██╗███████╗███████╗███████╗██████╗ 
 *    ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝██╔════╝██╔══██╗
 *       ██║   ██████╔╝███████║██╔██╗ ██║███████╗█████╗  █████╗  ██████╔╝
 *       ██║   ██╔══██╗██╔══██║██║╚██╗██║╚════██║██╔══╝  ██╔══╝  ██╔══██╗
 *       ██║   ██║  ██║██║  ██║██║ ╚████║███████║██║     ███████╗██║  ██║
 *       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Written on 02 JAN 2022
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../ERC721.sol";
import "./IERC721BatchTransfer.sol";

 /**
  * @dev this is an implementation of ERC1155's batch transfer functions,
  *  being batchTransfer() and safeBathTransfer() utilizing ERC721's built
  *  in transfer/safeTransfer functions. Will modify later to it's own code
  */

abstract contract ERC721BatchTransfer is ERC721, IERC721BatchTransfer {

  /**
   * @dev See {IERC721BatchTransfer-batchTransferFrom}.
   */
  function batchTransferFrom(
    address from,
    address to,
    uint256[] calldata tokenIds
  ) public virtual override {
    //solhint-disable-next-line max-line-length
    for(uint x = 0; x < tokenIds.length; x++) {
      require(_isApprovedOrOwner(_msgSender(), tokenIds[x]), "ERC721: transfer caller is not owner nor approved");
      _transfer(from, to, tokenIds[x]);
    }
    emit TransferBatch(_msgSender(), from, to, tokenIds);
  }

  /**
   * @dev See {IERC721BatchTransfer-safeBatchTransferFrom}.
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata tokenIds
  ) public virtual override {
    safeBatchTransferFrom(from, to, tokenIds, "");
  }

  /**
   * @dev See {IERC721BatchTransfer-safeBatchTransferFrom}.
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata tokenIds,
    bytes memory _data
  ) public virtual override {
    for(uint x = 0; x < tokenIds.length; x++) {
      require(_isApprovedOrOwner(_msgSender(), tokenIds[x]), "ERC721: transfer caller is not owner nor approved");
      _safeTransfer(from, to, tokenIds[x], _data);
    }
    emit TransferBatch(_msgSender(), from, to, tokenIds);
  }
}
