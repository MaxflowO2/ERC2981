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

interface IBAYC is IERC165{

  // ERC165
  // RevealTimestamp() => 0x83ba7c1d
  // RevealMD5Images() => 0xec0fad08
  // RevealMD5JSON() => 0x5798abef
  // RevealStartNumber() => 0x1efb051a
  // IBAYC => 0x26d67fe0

  // @notice will return timestamp of reveal
  // RevealTimestamp() => 0x83ba7c1d
  function RevealTimestamp() external view returns (uint256);

  // @notice will return MD5 hash of images on IPFS
  // RevealMD5Images() => 0xec0fad08
  function RevealMD5Images() external view returns (string memory);

  // @notice will return MD5 hash of images on IPFS
  // RevealMD5JSON() => 0x5798abef
  function RevealMD5JSON() external view returns (string memory);

  // @notice will return starting number for mint
  // RevealStartNumber() => 0x1efb051a
  function RevealStartNumber() external view returns (uint256);
}

