/***
 *    ██████╗  █████╗ ██╗   ██╗ ██████╗
 *    ██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝
 *    ██████╔╝███████║ ╚████╔╝ ██║     
 *    ██╔══██╗██╔══██║  ╚██╔╝  ██║     
 *    ██████╔╝██║  ██║   ██║   ╚██████╗
 *    ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Purpose: Insipired by BAYC on Ethereum, Sets Provential Hashes and More
 * Source: https://etherscan.io/address/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d#code
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../interface/IBAYC.sol";

///
/// @dev Implementation of IBAYC.sol 
///

abstract contract BAYC is IBAYC {

  // ERC165
  // RevealTimestamp() => 0x83ba7c1d
  // RevealProvenanceImages() => 0xd792d2a0
  // RevealProvenanceJSON() => 0x94352676
  // RevealStartNumber() => 0x1efb051a
  // BAYC => 0x515a7c7c

  event SetProvenanceImages(string _old, string _new);
  event SetProvenanceJSON(string _old, string _new);
  event SetTimestamp(uint _old, uint _new);
  event SetStartNumber(uint _old, uint _new);

  uint private timestamp;
  uint private startNumber;
  string private ProvenanceImages;
  string private ProvenanceJSON;

  // @notice will set reveal timestamp, used for
  //  REST API's, then emit an event, set to internal
  // @param _timestamp - unix timestamp
  function _setRevealTimestamp(uint256 _timestamp) internal {
    uint256 old = timestamp;
    timestamp = _timestamp;
    emit SetTimestamp(old, timestamp);
  }

  // @notice will set start number of the mint, set to internal
  // @param _startNumber - any uint between 0 and max minter
  //  capacity
  function _setStartNumber(uint256 _startNumber) internal {
    uint256 old = startNumber;
    startNumber = _startNumber;
    emit SetStartNumber(old, startNumber);
  }

  // @notice will set Metadata Provenance, set to internal
  // @param _ProvenanceJSON - A calculated sha256 hash by using
  //  4096 byte blocks of each metadata file, then the results are
  //  placed in sequence of mint, and hashed once again using sha256
  function _setProvenanceJSON(string memory _ProvenanceJSON) internal {
    string memory old = ProvenanceJSON;
    ProvenanceJSON = _ProvenanceJSON;
    emit SetProvenanceJSON(old, ProvenanceJSON);
  }

  // @notice will set Images Provenance, set to internal
  // @param _ProvenanceImages - A calculated sha256 hash by using
  //  4096 byte blocks of each image file, then the results are
  //  placed in sequence of mint, and hashed once again using sha256
  function _setProvenanceImages(string memory _ProvenanceImages) internal {
    string memory old = ProvenanceImages;
    ProvenanceImages = _ProvenanceImages;
    emit SetProvenanceImages(old, ProvenanceImages);
  }

  // @notice RevealTimestamp() Called to determine
  //  timestamp to reveal NFT's, used by REST API's
  // @return - uint timestamp
  // ERC165 Datum RevealTimestamp() => 0x83ba7c1d
  function RevealTimestamp() external view override(IBAYC) returns (uint) {
    return timestamp;
  }
  // @notice RevealProvenanceImages() Called to
  //  determine the Provenance Hash of the images
  // @return - string ProvenanceImages
  // ERC165 Datum RevealProvenanceImages() => 0xd792d2a0
  function RevealProvenanceImages() external view override(IBAYC) returns (string memory) {
    return ProvenanceImages;
  }

  // @notice RevealProvenanceJSON() called to
  //  determine the Provenance Hash of metadata
  // @return - string ProvenanceJSON
  // ERC165 Datum RevealProvenanceJSON() => 0x94352676
  function RevealProvenanceJSON() external view override(IBAYC) returns (string memory) {
    return ProvenanceJSON;
  }

  // @notice RevealStartNumber() called to
  //  determine the starting ID number of mint
  // @return - uint startNumber
  // ERC165 Datum RevealStartNumber() => 0x1efb051a
  function RevealStartNumber() external view override(IBAYC) returns (uint) {
    return startNumber;
  }
}
