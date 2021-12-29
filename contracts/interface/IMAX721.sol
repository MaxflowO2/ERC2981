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
/// @dev Interface for @MaxFlowO2's Contracts
///  must include or add totalSupply() to main
///

interface IMAX721 is IERC165 {

  // ERC165 data
  // minterStatus() => 0x2ecd28ab
  // minterFees() => 0xd95ae162
  // minterMaximumCapacity() => 0x78c5939b
  // minterMaximumTeamMints() => 0x049157bb
  // minterTeamMintsRemaining() => 0x5c17e370
  // minterTeamMintsCount() => 0xe68b7961
  // totalSupply() => 0x18160ddd
  // IMAX721 => 0x29499a25

  // @notice will return status of Minter
  // @return - bool of active or not
  // ERC165 datum minterStatus() => 0x2ecd28ab
  function minterStatus() external view returns (bool);

  // @notice will return minting fees
  // @return - uint of mint costs in wei
  // ERC165 datum minterFees() => 0xd95ae162
  function minterFees() external view returns (uint);

  // @notice will return maximum mint capacity
  // @return - uint of maximum mints allowed
  // ERC165 datum minterMaximumCapacity() => 0x78c5939b
  function minterMaximumCapacity() external view returns (uint);

  // @notice will return maximum "team minting" capacity
  // @return - uint of maximum airdrops or team mints allowed
  // ERC165 datum minterMaximumTeamMints() => 0x049157bb
  function minterMaximumTeamMints() external view returns (uint);

  // @notice will return "team mints" left
  // @return - uint of remaing airdrops or team mints
  // ERC165 datum minterTeamMintsRemaining() => 0x5c17e370
  function minterTeamMintsRemaining() external view returns (uint);

  // @notice will return "team mints" count
  // @return - uint of airdrops or team mints done
  // ERC165 datum minterTeamMintsCount() => 0xe68b7961
  function minterTeamMintsCount() external view returns (uint);

  // @notice will return current token count
  // @return - uint of how many NFT's minted on contract
  // ERC165 datum totalSupply() => 0x18160ddd
  function totalSupply() external view returns (uint);
}
