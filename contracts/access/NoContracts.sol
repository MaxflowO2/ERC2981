/***
 *     █████╗ ███╗   ██╗████████╗██╗                                       
 *    ██╔══██╗████╗  ██║╚══██╔══╝██║                                       
 *    ███████║██╔██╗ ██║   ██║   ██║                                       
 *    ██╔══██║██║╚██╗██║   ██║   ██║                                       
 *    ██║  ██║██║ ╚████║   ██║   ██║                                       
 *    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝                                       
 *                                                                         
 *     ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗
 *    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
 *    ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║   
 *    ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║   
 *    ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║   
 *     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Updated to ContextV2, on 03 Jan 2022
 */


// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "../utils/ContextV2.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an exclusion (any contracts) that can be granted exclusion to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `noContracts()`, which can be applied to your functions to restrict their use.
 */

abstract contract NoContracts is ContextV2 {
  using Address for address;

  modifier noContracts() {
    require(!_msgSender().isContract(), "Caller is a contract");
    /**
     * @dev this is check one, see Address.sol about warning
     */
    require(_msgSender() == _txOrigin(), "Caller is a contract");
    /**
     * @dev this is check two, killing the constructor hacks
     */
    _;
  }
}
