/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: IWhitelist.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Interface for WhitelistV2.sol
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IWhitelist is IERC165 {

  // @dev will return user status on whitelist
  // @return - bool if whitelist is enabled or not
  // @param myAddress - any user account address, EOA or contract
  function myWhitelistStatus(address myAddress) external view returns (bool);

  // @dev will return status of whitelist
  // @return - bool if whitelist is enabled or not
  function whitelistStatus() external view returns (bool);

  // @dev will return whitelist end (quantity or time)
  // @return - uint of either number of whitelist mints or
  //  a timestamp
  function whitelistEnd() external view returns (uint);

  // @dev will return totat on whitelist
  // @return - uint from CountersV2.Count
  function TotalOnWhitelist() external view returns (uint);

  // @dev will return totat used on whitelist
  // @return - uint from CountersV2.Count
  function TotalWhiteListUsed() external view returns (uint);

  // @dev will return totat used on whitelist
  // @return - uint aka xxxx = xx.xx%
  function WhitelistEfficiency() external view returns (uint);

}
