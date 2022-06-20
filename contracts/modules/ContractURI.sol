/***
 *     ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗    ██╗   ██╗██████╗ ██╗
 *    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝    ██║   ██║██╔══██╗██║
 *    ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║       ██║   ██║██████╔╝██║
 *    ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║       ██║   ██║██╔══██╗██║
 *    ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║       ╚██████╔╝██║  ██║██║
 *     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝        ╚═════╝ ╚═╝  ╚═╝╚═╝
 * @author: @MaxFlowO2
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Purpose: OpenSea compliance on chain ID #1-5
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../interface/IContractURI.sol";

///
/// @dev Implementation of IContractURI.sol
///

abstract contract ContractURI is IContractURI {

  event ContractURIChange(string _old, string _new);

  string private thisContractURI;

  // @notice this sets the contractURI, set to internal
  // @param newURI - string to URI of Contract Metadata
  //  used for OpenSea and OpenSea-esque Secondary Marketplaces
  function _setContractURI(string memory newURI) internal {
    string memory old = thisContractURI;
    thisContractURI = newURI;
    emit ContractURIChange(old, thisContractURI);
  }

  // @notice this clears the contractURI, set to internal
  function _clearContractURI() internal {
    string memory old = thisContractURI;
    delete thisContractURI;
    emit ContractURIChange(old, thisContractURI);
  }

  // @notice contractURI() called for retreval of
  //  OpenSea style collections pages
  // @return - string thisContractURI
  function contractURI() external view override(IContractURI) returns (string memory) {
    return thisContractURI;
  }

}
