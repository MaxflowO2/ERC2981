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
/// @dev this is the standard interface for @MaxflowO2's 
///  whitelist contracts
///

interface IMAX721Whitelist is IERC165 {

  // ERC165 data
  // whitelistStatus() => 0x9ddf7ad3
  // whitelistEnd() => 0xbfb6e0e7
  // IMAX721Whitelist => 0x22699a34

  // @notice will return status of whitelist
  // @return - bool if whitelist is enabled or not
  // ERC165 datum whitelistStatus() => 0x9ddf7ad3
  function whitelistStatus() external view returns (bool);

  // @notice will return whitelist end (quantity or time)
  // @return - uint of either number of whitelist mints or
  //  a timestamp
  // ERC165 datum IMAX721Whitelist => 0x22699a34
  function whitelistEnd() external view returns (uint);
}
