/***
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

///
/// @dev Implementation of a whitelist, use case anywhere
///

abstract contract Whitelist {

  // ERC165 data
  // Public getter isWhitelist(address) => 0xc683630d
  // Whitelist is 0xc683630d

  event ChangeToWhitelist(address _address, bool old, bool update);

  // @notice this is the main mapping of this contract
  // @param address - unter any address to retrieve bool
  // @return bool - true/fale if they are on the whitelist
  // ERC165 datum isWhitelist(address) => 0xc683630d
  mapping(address => bool) public isWhitelist;

  // @notice this adds addresses to the mapping isWhitelist, set
  //  to internal, passes individual addresses to _addWhitelist(address)
  // @param address[] _addresses - and array/list of addresses
  function _addWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      _addWhitelist(_addresses[i]);
    }
  }

  // @notice this adds one address to the mapping isWhitelist, set
  //  to internal, emits event ChangeToWhitelist(address, old, current)
  // @param _address - an addresses
  function _addWhitelist(address _address) internal {
    require(!isWhitelist[_address], "Already on Whitelist");
    bool old = isWhitelist[_address];
    isWhitelist[_address] = true;
    emit ChangeToWhitelist(_address, old, isWhitelist[_address]);
  }

  // @notice this removes addresses to the mapping isWhitelist, set
  //  to internal, passes individual addresses to _removeWhitelist(address)
  // @param address[] _addresses - and array/list of addresses
  function _removeWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      _removeWhitelist(_addresses[i]);
    }
  }

  // @notice this removes one address to the mapping isWhitelist, set
  //  to internal, emits event ChangeToWhitelist(address, old, current)
  // @param _address - an addresses
  function _removeWhitelist(address _address) internal {
    require(isWhitelist[_address], "Already off Whitelist");
    bool old = isWhitelist[_address];
    isWhitelist[_address] = false;
    emit ChangeToWhitelist(_address, old, isWhitelist[_address]);
  }
}
