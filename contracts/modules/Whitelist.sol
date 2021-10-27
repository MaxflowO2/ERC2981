/***
 *    ██╗    ██╗██╗  ██╗██╗████████╗███████╗               
 *    ██║    ██║██║  ██║██║╚══██╔══╝██╔════╝               
 *    ██║ █╗ ██║███████║██║   ██║   █████╗█████╗           
 *    ██║███╗██║██╔══██║██║   ██║   ██╔══╝╚════╝           
 *    ╚███╔███╔╝██║  ██║██║   ██║   ███████╗               
 *     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝               
 *                                                         
 *    ██╗     ██╗███████╗████████╗███████╗ ██████╗ ██╗     
 *    ██║     ██║██╔════╝╚══██╔══╝██╔════╝██╔═══██╗██║     
 *    ██║     ██║███████╗   ██║   ███████╗██║   ██║██║     
 *    ██║     ██║╚════██║   ██║   ╚════██║██║   ██║██║     
 *    ███████╗██║███████║   ██║██╗███████║╚██████╔╝███████╗
 *    ╚══════╝╚═╝╚══════╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚══════╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

abstract contract Whitelist {

  // ERC165
  // _addWhitelistBatch(address[]) => 0xfcc348ba
  // _addWhitelist(address) => 0xcc64ecf2
  // _removeWhitelistBatch(address[]) => 0xec7a834d
  // _removeWhitelistBatch(address[]) => 0xec7a834d
  // Whitelist => 0xaab9e3bd

  // set contract mapping
  mapping(address => bool) public isWhitelist;

  // only event needed
  event ChangeToWhitelist(address _address, bool update);

  // adding functions to mapping
  // _addWhitelistBatch(address[]) => 0xfcc348ba
  function _addWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      isWhitelist[_addresses[i]] = true;
      emit ChangeToWhitelist(_addresses[i], isWhitelist[_addresses[i]]);
    }
  }

  // _addWhitelist(address) => 0xcc64ecf2
  function _addWhitelist(address _address) internal {
    isWhitelist[_address] = true;
    emit ChangeToWhitelist(_address, isWhitelist[_address]);
  }

  // removing functions to mapping
  // _removeWhitelistBatch(address[]) => 0xec7a834d
  function _removeWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      isWhitelist[_addresses[i]] = false;
      emit ChangeToWhitelist(_addresses[i], isWhitelist[_addresses[i]]);
    }
  }

  // _removeWhitelist(address) => 0x7664c4b8
  function _removeWhitelist(address _address) internal {
    isWhitelist[_address] = false;
    emit ChangeToWhitelist(_address, isWhitelist[_address]);
  }
}
