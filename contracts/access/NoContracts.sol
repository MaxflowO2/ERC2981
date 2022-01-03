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
 * there is an exclusion (any contracts) that can be on specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `noContracts()`, which can be applied to your functions to restrict their use.
 */

abstract contract NoContracts is ContextV2 {
  using Address for address;

  modifier noContracts() {
    require(!_msgSender().isContract(), "Caller is a contract");

    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */

    require(_msgSender() == _txOrigin(), "Caller is a contract");

    /**
     * @dev Returns false if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * By using msg.sender and tx.origin and ensuring they are equal, this
     * as of solidity 0.8.11 will ensure the call was made by an EOA.
     *
     * This will prevent
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe.
     * ====
     */

    _;
  }
}
