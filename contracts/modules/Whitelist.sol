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

  // set contract mapping
  mapping (address => bool) isWhitelist;

  // only event needed
  event ChangeToWhitelist(address _address, bool update);

  // adding functions to mapping
  function _addWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      isWhitelist[_addresses[i]] = true;
      emit ChangeToWhitelist(_addresses[i], isWhitelist[_addresses[i]]);
    }
  }

  function _addWhitelist(address _address) internal {
    isWhitelist[_address] = true;
    emit ChangeToWhitelist(_address, isWhitelist[_address]);
  }

  // removing functions to mapping
  function _removeWhitelistBatch(address [] memory _addresses) internal {
    for (uint i = 0; i < _addresses.length; i++) {
      isWhitelist[_addresses[i]] = false;
      emit ChangeToWhitelist(_addresses[i], isWhitelist[_addresses[i]]);
    }
  }

  function _removeWhitelist(address _address) internal {
    isWhitelist[_address] = false;
    emit ChangeToWhitelist(_address, isWhitelist[_address]);
  }
}
