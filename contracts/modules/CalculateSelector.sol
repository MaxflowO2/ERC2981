/***
 *    ███████╗██████╗  ██████╗ ██╗ ██████╗ ███████╗
 *    ██╔════╝██╔══██╗██╔════╝███║██╔════╝ ██╔════╝
 *    █████╗  ██████╔╝██║     ╚██║███████╗ ███████╗
 *    ██╔══╝  ██╔══██╗██║      ██║██╔═══██╗╚════██║
 *    ███████╗██║  ██║╚██████╗ ██║╚██████╔╝███████║
 *    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝ ╚══════╝
 *                                                 
 *     ██████╗ █████╗ ██╗      ██████╗             
 *    ██╔════╝██╔══██╗██║     ██╔════╝             
 *    ██║     ███████║██║     ██║                  
 *    ██║     ██╔══██║██║     ██║                  
 *    ╚██████╗██║  ██║███████╗╚██████╗             
 *     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝             
 * Orginal Source:
 * https://kovan.etherscan.io/address/0x07d74cf0ce4a1b10ece066725db1731515d62b76#code
 * Rewritten by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract CalculateSelector {

    // @notice basic run down, single selector
    // Example: ERC721
    // bytes4(keccak256('name()')) == 0x06fdde03
    function getSelector(string memory signature) public pure returns(bytes4) {
        return bytes4(keccak256(bytes(signature)));
    }

    // @notice basic run down, multiple selectors
    // Example: ERC721
    // bytes4(keccak256('name()')) == 0x06fdde03
    // bytes4(keccak256('symbol()')) == 0x95d89b41
    // bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
    //
    // => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
    function getSupportedInterface(bytes4[] memory selectors) public pure returns(bytes4) {
        bytes4 result = 0x00000000;
        for (uint i = 0; i < selectors.length; i++) {
            result = result ^ selectors[i];
        }
        return result;
    }
}
