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
 *
 *    ██╗    ██╗██╗  ██╗██╗████████╗███████╗██╗     ██╗███████╗████████╗
 *    ██║    ██║██║  ██║██║╚══██╔══╝██╔════╝██║     ██║██╔════╝╚══██╔══╝
 *    ██║ █╗ ██║███████║██║   ██║   █████╗  ██║     ██║███████╗   ██║   
 *    ██║███╗██║██╔══██║██║   ██║   ██╔══╝  ██║     ██║╚════██║   ██║   
 *    ╚███╔███╔╝██║  ██║██║   ██║   ███████╗███████╗██║███████║   ██║   
 *     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝╚══════╝   ╚═╝   
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

  ///
  /// Developer this is the standard interface for all ERC721's written by myself
  ///

interface IMAX721Whitelist is IERC165 {
  // Must calculate IERC165 interface bytes4
  // and add later... stay tuned

  // @notice will return status of whitelist
  function whitelistStatus() external view returns (bool);

  // @notice will return whitelist end (quantity or time)
  function whitelistEnd() external view returns (uint256);
}
