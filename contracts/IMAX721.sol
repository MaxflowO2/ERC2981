/***
 *    ██╗███╗   ██╗████████╗███████╗██████╗ ███████╗ █████╗  ██████╗███████╗
 *    ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝
 *    ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  ███████║██║     █████╗  
 *    ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║     ██╔══╝  
 *    ██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ██║  ██║╚██████╗███████╗
 *    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝
 *                                                                          
 *    ███╗   ███╗ █████╗ ██╗  ██╗  ███████╗██████╗  ██╗                     
 *    ████╗ ████║██╔══██╗╚██╗██╔╝  ╚════██║╚════██╗███║                     
 *    ██╔████╔██║███████║ ╚███╔╝█████╗ ██╔╝ █████╔╝╚██║                     
 *    ██║╚██╔╝██║██╔══██║ ██╔██╗╚════╝██╔╝ ██╔═══╝  ██║                     
 *    ██║ ╚═╝ ██║██║  ██║██╔╝ ██╗     ██║  ███████╗ ██║                     
 *    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝  ╚══════╝ ╚═╝                     
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

  ///
  /// @Dev this is the standard interface for all ERC721's written by myself
  ///

interface IMAX721 is IERC165 {
  // Must calculate IERC165 interface bytes4
  // and add later... stay tuned

  // @notice will return status of Minter
  function minterStatus() external view returns (bool);

  // @notice will return minting fees
  function minterFees() external view returns (uint256);

  // @notice will return maximum mint capacity
  function minterMaximumCapacity() external view returns (uint256);

  // @notice will return maximum "team minting" capacity
  function minterMaximumTeamMints() external view returns (uint256);

  // @notice will return "team mints" left
  function minterTeamMintsRemaining() external view returns (uint256);

  // @notice will return current token count
  function minterCurrentCount() external view returns (uint256);
}
