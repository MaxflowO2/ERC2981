/***
 *    ██████╗ ███████╗██╗   ██╗███████╗██╗      ██████╗ ██████╗ ███████╗██████╗ 
 *    ██╔══██╗██╔════╝██║   ██║██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝██╔══██╗
 *    ██║  ██║█████╗  ██║   ██║█████╗  ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
 *    ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗
 *    ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗╚██████╔╝██║     ███████╗██║  ██║
 *    ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
 * This is a re-write of @openzeppelin/contracts/access/Ownable.sol
 * Rewritten by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Upgraded to push/pull and decline by @MaxFlowO2 on 29 Dec 2021
 * Updated to ContextV2, and removed ERC165 calculations on 31 Dec 2021
 */

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2
// Rewritten for onlyDev modifier

pragma solidity >=0.8.0 <0.9.0;

import "../utils/ContextV2.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (a developer) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the developer account will be the one that deploys the contract. This
 * can later be changed with {transferDeveloper}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyDev`, which can be applied to your functions to restrict their use to
 * the developer.
 */

abstract contract DeveloperV2 is ContextV2 {

    address private _developer;
    address private _newDeveloper;

    event DeveloperTransferred(address indexed previousDeveloper, address indexed newDeveloper);

    /**
     * @dev Initializes the contract setting the deployer as the initial developer.
     */
    constructor() {
        _transferDeveloper(_msgSender());
    }

    /**
     * @dev Returns the address of the current developer.
     */
    function developer() public view virtual returns (address) {
        return _developer;
    }

    /**
     * @dev Throws if called by any account other than the developer.
     */
    modifier onlyDev() {
        require(developer() == _msgSender(), "Developer: caller is not the developer");
        _;
    }

    /**
     * @dev Leaves the contract without developer. It will not be possible to call
     * `onlyDev` functions anymore. Can only be called by the current developer.
     *
     * NOTE: Renouncing developership will leave the contract without an developer,
     * thereby removing any functionality that is only available to the developer.
     */
    function renounceDeveloper() public virtual onlyDev {
        _transferDeveloper(address(0));
    }

    /**
     * @dev Transfers Developer of the contract to a new account (`newDeveloper`).
     * Can only be called by the current developer. Now push/pull.
     */
    function transferDeveloper(address newDeveloper) public virtual onlyDev {
        require(newDeveloper != address(0), "Developer: new developer is the zero address");
        _newDeveloper = newDeveloper;
    }

    /**
     * @dev Accepts Transfer Developer of the contract to a new account (`newDeveloper`).
     * Can only be called by the new developer. Pull Accepted.
     */
    function acceptDeveloper() public virtual {
        require(_newDeveloper == _msgSender(), "New Developer: new developer is the only caller");
        _transferDeveloper(_newDeveloper);
    }

    /**
     * @dev Declines Transfer Developer of the contract to a new account (`newDeveloper`).
     * Can only be called by the new developer. Pull Declined
     */
    function declineDeveloper() public virtual {
        require(_newDeveloper == _msgSender(), "New Developer: new developer is the only caller");
        _newDeveloper = address(0);
    }

    /**
     * @dev Transfers Developer of the contract to a new account (`newDeveloper`).
     * Can only be called by the current developer. Now push only. Orginal V1 style
     */
    function pushDeveloper(address newDeveloper) public virtual onlyDev {
        require(newDeveloper != address(0), "Developer: new developer is the zero address");
        _transferDeveloper(newDeveloper);
    }

    /**
     * @dev Transfers Developer of the contract to a new account (`newDeveloper`).
     * Internal function without access restriction.
     */
    function _transferDeveloper(address newDeveloper) internal virtual {
        address oldDeveloper = _developer;
        _developer = newDeveloper;
        emit DeveloperTransferred(oldDeveloper, newDeveloper);
    }
}
