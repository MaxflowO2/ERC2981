/***
 *    ███████╗██████╗  ██████╗███████╗██████╗  ██╗    ██╗   ██╗██████╗                
 *    ██╔════╝██╔══██╗██╔════╝╚════██║╚════██╗███║    ██║   ██║╚════██╗               
 *    █████╗  ██████╔╝██║         ██╔╝ █████╔╝╚██║    ██║   ██║ █████╔╝               
 *    ██╔══╝  ██╔══██╗██║        ██╔╝ ██╔═══╝  ██║    ╚██╗ ██╔╝██╔═══╝                
 *    ███████╗██║  ██║╚██████╗   ██║  ███████╗ ██║     ╚████╔╝ ███████╗               
 *    ╚══════╝╚═╝  ╚═╝ ╚═════╝   ╚═╝  ╚══════╝ ╚═╝      ╚═══╝  ╚══════╝               
 *                                                                                    
 *     ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
 *    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
 *    ██║     ██║   ██║██║     ██║     █████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██║
 *    ██║     ██║   ██║██║     ██║     ██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██║
 *    ╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
 *     ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Developer.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC2981Collection.sol";

contract ERC is ERC721, ERC2981Collection, Developer, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    string private base;

    constructor() ERC721("ERC", "721") {}

    function _baseURI() internal pure override returns (string memory) {
        return base;
    }

    function setBaseURI(string _base) public onlyDev {
        base = _base;
    }

    function safeMint(address to) public onlyOwner {
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }
}
