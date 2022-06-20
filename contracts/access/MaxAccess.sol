/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: MaxAccess.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Access control based off EIP 173/roles from OZ
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./IOwner.sol";
import "./IDeveloper.sol";
import "../lib/Roles.sol";
import "../utils/ContextV2.sol";

abstract contract MaxAccess is IOwner, IDeveloper, ContextV2 {
  using Roles for Roles.Role;

  Roles.Role private contractRoles;

  bytes4 constant private DEVS = 0xca4b208b; // ERC165 calc of developer()
  bytes4 constant private PENDING_DEVS = 0xca4b208c; // DEVS++
  bytes4 constant private OWNERS = 0x8da5cb5b; // ERC165 calc of owner()
  bytes4 constant private PENDING_OWNERS = 0x8da5cb5c; // OWNER++

  error Unauthorized();

  constructor() {
    init();
  }

  function init() internal {
    contractRoles.add(OWNERS, _msgSender());
    contractRoles.add(DEVS, _msgSender());
  }

  function owner(address _user) external view virtual override(IOwner) returns (bool) {
    return contractRoles.has(OWNERS, _user);
  }

  modifier onlyOwner() {
    if (!owner(_msgSender())) {
      revert Unauthorized();
    }
    _;
  }

  function renounceOwner() external virtual override(IOwner) onlyOwner() {
    contractRoles.remove(OWNERS, _msgSender());
  }

  function transferOwner(address newOwner) external override(IOwner) onlyOwner() {
    contractRoles.add(PENDING_OWNERS, _msgSender());
  }

  function acceptOwner() external virtual override(IOwner) {
    if (!contractRole.has(PENDING_OWNERS, _msgSender())) {
      revert Unauthorized();
    }
    contractRole.remove(PENDING_OWNERS, _msgSender());
    contractRole.add(OWNERS, _msgSender());
  }

  function declineOwner() external virtual override(IOwner) {
    if (!contractRole.has(PENDING_OWNERS, _msgSender())) {
      revert Unauthorized();
    }
    contractRole.remove(PENDING_OWNERS, _msgSender());
  }

  function pushOwner(address newOwner) external virtual override(IOwner) onlyOwner() {
    contractRole.add(OWNERS, newOwner);
  }

  function developer(address _user) external view virtual override(IDeveloper) returns (bool) {
    return contractRoles.has(DEVS, _user);
  }

  modifier onlyDev() {
    if (!developer(_msgSender())) {
      revert Unauthorized();
    }
    _;
  }

  function renounceDeveloper() external virtual override(IDeveloper) onlyDev() {
    contractRoles.remove(DEVS, _msgSender());
  }

  function transferDeveloper(address newDeveloper) external override(IDeveloper) onlyDev() {
    contractRoles.add(PENDING_DEVS, _msgSender());
  }

  function acceptDeveloper() external virtual override(IDeveloper) {
    if (!contractRole.has(PENDING_DEVS, _msgSender())) {
      revert Unauthorized();
    }
    contractRole.remove(PENDING_DEVS, _msgSender());
    contractRole.add(DEVS, _msgSender());
  }

  function declineDeveloper() external virtual override(IDeveloper) {
    if (!contractRole.has(PENDING_DEVS, _msgSender())) {
      revert Unauthorized();
    }
    contractRole.remove(PENDING_DEVS, _msgSender());
  }

  function pushDeveloper(address newDeveloper) external virtual override(IDeveloper) onlyDev() {
    contractRole.add(DEVS, newDeveloper);
  }

  function supportsInterface(bytes4 interfaceId) public view override(IOwner, IDeveloper, IERC165) returns (bool) {
    return (
      interfaceId == type(IOwner).interfaceId  ||
      interfaceId == type(IDeveloper).interfaceId  ||
      super.supportsInterface(interfaceId)
    );
  }
}
