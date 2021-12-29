/***
 *    ██╗██████╗  █████╗ ██╗   ██╗ ██████╗
 *    ██║██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝
 *    ██║██████╔╝███████║ ╚████╔╝ ██║     
 *    ██║██╔══██╗██╔══██║  ╚██╔╝  ██║     
 *    ██║██████╔╝██║  ██║   ██║   ╚██████╗
 *    ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Purpose: Insipired by BAYC on Ethereum, Sets Provential Hashes and More
 * Source: https://etherscan.io/address/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d#code
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

///
/// @dev Interface for the BAYC Standard v2.0
///  this includes metadata with images
///

interface IBAYC is IERC165{

  // ERC165
  // RevealTimestamp() => 0x83ba7c1d
  // RevealProvenanceImages() => 0xd792d2a0
  // RevealProvenanceJSON() => 0x94352676
  // RevealStartNumber() => 0x1efb051a
  // IBAYC => 0x515a7c7c


  // @notice RevealTimestamp() Called to determine 
  //  timestamp to reveal NFT's, used by REST API's
  // @return - the uint timestamp of reval in unix time
  // ERC165 Datum RevealTimestamp() => 0x83ba7c1d
  function RevealTimestamp() external view returns (uint);

  // @notice RevealProvenanceImages() Called to 
  //  determine the Provenance Hash of the images
  // @return - the string of the Provenance Hash
  // ERC165 Datum RevealProvenanceImages() => 0xd792d2a0
  function RevealProvenanceImages() external view returns (string memory);

  // @notice RevealProvenanceJSON() called to 
  //  determine the Provenance Hash of metadata
  // @return - the string of the Provenance Hash
  // ERC165 Datum RevealProvenanceJSON() => 0x94352676
  function RevealProvenanceJSON() external view returns (string memory);

  // @notice RevealStartNumber() called to
  //  determine the starting ID number of mint
  // @return - the uint of first ID to be minted
  // ERC165 Datum RevealStartNumber() => 0x1efb051a
  function RevealStartNumber() external view returns (uint);
}
