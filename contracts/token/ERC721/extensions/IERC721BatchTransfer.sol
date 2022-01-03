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

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

 /**
  * @dev this is an implementation of ERC1155's batch transfer functions,
  *  being batchTransfer() and safeBathTransfer() utilizing ERC721's built
  *  in transfer/safeTransfer functions. Will modify later to it's own code
  */

interface IERC721BatchTransfer is IERC165 {

  /**
   *  @notice this is the event emitted for batch transfer
   *  @param operator - _msgSender()
   *  @param from - address from
   *  @param to - addres sent to
   *  @param ids - list/array of token id's that transferred
   */
  event TransferBatch(
    address indexed operator,
    address indexed from,
    address indexed to,
    uint256[] ids
  );

  /**
   *  @notice this is the function for batch transfer
   *  @param from - address from
   *  @param to - addres sent to
   *  @param ids - list/array of token id's that transferred
   */
  function batchTransferFrom(
    address from,
    address to,
    uint256[] calldata ids
  ) external;

  /**
   *  @notice this is the function for safe batch transfer
   *  @param from - address from
   *  @param to - addres sent to
   *  @param ids - list/array of token id's that transferred
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata ids
  ) external;

  /**
   *  @notice this is the function for safe batch transfer
   *  @param from - address from
   *  @param to - addres sent to
   *  @param ids - list/array of token id's that transferred
   *  @param data - unformatted data
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata ids,
    bytes calldata data
  ) external;

}
