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

abstract contract BAYC is IBAYC {

  // ERC165
  // _setRevealTimestamp(uint256) => 0x20add1a4
  // _setStartNumber(uint256) => 0x4266377e
  // _setMD5JSON(string) => 0x86d5c695
  // _setMD5Images(string) => 0x861f7c45
  // RevealTimestamp() => 0x83ba7c1d
  // RevealMD5Images() => 0xec0fad08
  // RevealMD5JSON() => 0x5798abef
  // RevealStartNumber() => 0x1efb051a
  // BAYC => 0x44d723ea

  event SetMD5Images(string _old, string _new);
  event SetMD5JSON(string _old, string _new);
  event SetTimestamp(uint _old, uint _new);
  event SetStartNumber(uint _old, uint _new);

  uint256 private timestamp;
  uint256 private startNumber;
  string private MD5Images;
  string private MD5JSON;

  // @notice will set reveal timestamp
  // _setRevealTimestamp(uint256) => 0x20add1a4
  function _setRevealTimestamp(uint256 _timestamp) internal {
    uint256 old = timestamp;
    timestamp = _timestamp;
    emit SetTimestamp(old, timestamp);
  }

  // @notice will set start number
  // _setStartNumber(uint256) => 0x4266377e
  function _setStartNumber(uint256 _startNumber) internal {
    uint256 old = startNumber;
    startNumber = _startNumber;
    emit SetStartNumber(old, startNumber);
  }

  // @notice will set JSON MD5
  // _setMD5JSON(string) => 0x86d5c695
  function _setMD5JSON(string memory _MD5JSON) internal {
    string memory old = MD5JSON;
    MD5JSON = _MD5JSON;
    emit SetMD5JSON(old, MD5JSON);
  }

  // @notice will set Images MD5
  // _setMD5Images(string) => 0x861f7c45
  function _setMD5Images(string memory _MD5Images) internal {
    string memory old = MD5Images;
    MD5Images = _MD5Images;
    emit SetMD5Images(old, MD5Images);
  }

  // @notice will return timestamp of reveal
  // RevealTimestamp() => 0x83ba7c1d
  function RevealTimestamp() external view override(IBAYC) returns (uint256) {
    return timestamp;
  }

  // @notice will return MD5 hash of images on IPFS
  // RevealMD5Images() => 0xec0fad08
  function RevealMD5Images() external view override(IBAYC) returns (string memory) {
    return MD5Images;
  }

  // @notice will return MD5 hash of images on IPFS
  // RevealMD5JSON() => 0x5798abef
  function RevealMD5JSON() external view override(IBAYC) returns (string memory) {
    return MD5JSON;
  }

  // @notice will return starting number for mint
  // RevealStartNumber() => 0x1efb051a
  function RevealStartNumber() external view override(IBAYC) returns (uint256) {
    return startNumber;
  }

}
