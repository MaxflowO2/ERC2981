/***
 *    ██████╗ ███████╗██╗   ██╗███████╗██╗      ██████╗ ██████╗ ███████╗██████╗ 
 *    ██╔══██╗██╔════╝██║   ██║██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝██╔══██╗
 *    ██║  ██║█████╗  ██║   ██║█████╗  ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
 *    ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗
 *    ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗╚██████╔╝██║     ███████╗██║  ██║
 *    ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
 *
 * Re-write of @openzeppelin/contracts/access/Ownable.sol by MaxflowO2
 * Use case: Only need 2 Roles and don't want to set another mapping
 * Follow me on Twitter @MaxflowO2 or GitHub https://github.com/MaxflowO2
 */

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2
// Rewritten for onlyDev modifier

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";

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
abstract contract Developer is Context {
    address private _developer;

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
     * Can only be called by the current developer.
     */
    function transferDeveloper(address newDeveloper) public virtual onlyDev {
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
