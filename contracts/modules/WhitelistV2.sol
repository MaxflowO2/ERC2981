/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: WhitelistV2.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Standalone contract for whitelists to be imported to boiler plate
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../lib/Whitelist.sol";
import "./IWhitelist.sol";

abstract contract WhitelistV2 is IWhitelist {
  using Whitelist for Whitelist.List;
  
  Whitelist.List private whitelist;

  // @dev will add one address to whitelist
  // @param newAddress - solo address
  function _addWhitelist(
   address newAddress
 ) internal {
    whitelist.add(newAddress);
  }


  // @dev will batch add whitelist addresses
  // @param newAddresses - array of addresses
  function _addBatchWhitelist(
    address[] memory newAddresses
  ) internal {
    uint length = newAddresses.length;
    for(uint x = 0; x < length;) {
      whitelist.add(newAddresses[x]);
      unchecked { ++x; }
    }
  }

  // @dev will remove one address from whitelist
  // @param newAddress - solo address
  function _removeWhitelist(
    address newAddress
  ) internal {
    whitelist.remove(newAddress);
  }

  // @dev will batch remove whitelist addresses
  // @param newAddresses - array of addresses
  function _removeBatchWhitelist(
    address[] memory newAddresses
  ) internal {
    uint length = newAddresses.length;
    for(uint x = 0; x < length;) {
      whitelist.remove(newAddresses[x]);
      unchecked { ++x; }
    }
  }

  // @dev will enable the whitelist
  function _enableWhitelist() internal {
    whitelist.enable();
  }

  // @dev will disable the whitelist
  function _disableWhitelist() internal {
    whitelist.disable();
  }

  // @notice rename this to whatever you want timestamp/quant of tokens sold
  // @dev will set the ending uint of whitelist
  // @param endNumber - uint for the end (quant or timestamp)
  function _setEndOfWhitelist(
    uint endNumber
  ) internal {
    whitelist.setEnd(endNumber);
  }

  // @dev will return user status on whitelist
  // @return - bool if whitelist is enabled or not
  // @param myAddress - any user account address, EOA or contract
  function _myWhitelistStatus(
    address myAddress
  ) internal
    view
    returns (bool) {
    return whitelist.onList(myAddress);
  }

  // @dev will return user status on whitelist
  // @return - bool if whitelist is enabled or not
  // @param myAddress - any user account address, EOA or contract
  function myWhitelistStatus(
    address myAddress
  ) external
    view
    override(IWhitelist)
    returns (bool) {
    return whitelist.onList(myAddress);
  }

  // @dev will return status of whitelist
  // @return - bool if whitelist is enabled or not
  function whitelistStatus()
    external
    view
    override(IWhitelist)
    returns (bool) {
    return whitelist.status();
  }

  // @dev will return whitelist end (quantity or time)
  // @return - uint of either number of whitelist mints or
  //  a timestamp
  function whitelistEnd()
    external
    view
    override(IWhitelist)
    returns (uint) {
    return whitelist.showEnd();
  }

  // @dev will return totat on whitelist
  // @return - uint from CountersV2.Count
  function TotalOnWhitelist()
    external
    view
    override(IWhitelist)
    returns (uint) {
    return whitelist.totalAdded();
  }

  // @dev will return totat used on whitelist
  // @return - uint from CountersV2.Count
  function TotalWhiteListUsed()
    external
    view
    override(IWhitelist)
    returns (uint) {
    return whitelist.totalRemoved();
  }

  // @dev will return totat used on whitelist
  // @return - uint aka xxxx = xx.xx%
  function WhitelistEfficiency()
    external
    view
    override(IWhitelist)
    returns (uint) {
    if(whitelist.totalRemoved() == 0) {
      return 0;
    } else {
      return whitelist.totalRemoved() * 10000 / whitelist.totalAdded();
    }
  }

  // @notice solidity required override for supportsInterface(bytes4)
  // @param bytes4 interfaceId - bytes4 id per interface or contract
  function supportsInterface(
    bytes4 interfaceId
  ) public
    view
    override(IERC165)
    returns (bool) {
    return (
      interfaceId == type(IWhitelist).interfaceId  ||
      super.supportsInterface(interfaceId)
    );
  }
}
