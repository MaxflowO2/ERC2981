/***
 *    ██╗██████╗ ███████╗███████╗    ██████╗  █████╗ ████████╗ █████╗ 
 *    ██║██╔══██╗██╔════╝██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
 *    ██║██████╔╝█████╗  ███████╗    ██║  ██║███████║   ██║   ███████║
 *    ██║██╔═══╝ ██╔══╝  ╚════██║    ██║  ██║██╔══██║   ██║   ██╔══██║
 *    ██║██║     ██║     ███████║    ██████╔╝██║  ██║   ██║   ██║  ██║
 *    ╚═╝╚═╝     ╚═╝     ╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

abstract contract IPFSMetadata {

  // set contract mapping
  mapping (uint256 => string) dataIPFS;

  // do not set any other events!
  event UpdatedIPFS(uint256 id);

  // adding functions to mapping
  function _addDataIPFSBatch(uint256 [] memory _ids, string [] memory _hash) internal {
    require(_ids.length == _hash.length, "Size mismatch");
    for (uint i = 0; i < _ids.length; i++) {
      dataIPFS[_ids[i]] = _hash[i];
      emit UpdatedIPFS(_ids[i]);
    }
  }

  function _addDataIPFS(uint256 _id, string memory _hash) internal {
    dataIPFS[_id] = _hash;
    emit UpdatedIPFS(_id);
  }
}
