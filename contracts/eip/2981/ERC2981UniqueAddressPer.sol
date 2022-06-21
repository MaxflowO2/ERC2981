/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: ERC2981UniqueAddressPer.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Use case for EIP 2981, steered more towards NFT Collections as a whole
 *  has a unique address per NFT attribute
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./IERC2981.sol";

abstract contract ERC2981UniqueAddressPer is IERC2981 {

  mapping(uint256 => address) private royaltyAddress;
  uint256 private royaltyPermille;

  event royalatiesSet(
          uint token
        , uint value
        , address recipient);
  event royaltyPermilleSet(uint value);
  error Unauthorized();

  // @dev to set roaylties on contract via EIP 2891
  // @param _receiver, address of recipient
  // @param _tokenId, uint of token ID to be checked
  function _setRoyalties(
    uint256 _tokenId
  , address _receiver
  ) internal {
    royaltyAddress[_tokenId] = _receiver;
    emit royalatiesSet(_tokenId, royaltyPermille, _receiver)
  }

  // @dev used to set global permille
  // @param _permille, uint of permille (xx.x% -> xxx)
  function _setPermille (
    uint256 _permille
  ) internal {
    if (_permille > 1001 || _permille == 0) {
      revert Unauthorized();
    }
    royaltyPermille = _permille;
    emit royaltyPermilleSet(royaltyPermille);
  }

  // @dev to remove royalties from contract
  // @param _tokenId, uint of token ID to be checked
  function _removeRoyalties(
    uint256 _tokenId
  ) internal {
    royalty[_tokenId] = address(0);
    toyaltyPercent = 0;
    emit royalatiesSet(_tokenId, 0, address(0));
  }

  // @dev Override for royaltyInfo(uint256, uint256)
  // @param _tokenId, uint of token ID to be checked
  // @param _salePrice, uint of amount of sale
  // @return receiver, address of recipient
  // @return royaltyAmount, amount royalties recieved
  function royaltyInfo(
    uint256 _tokenId,
    uint256 _salePrice
  ) external
    view
    override(IERC2981)
    returns (
    address receiver,
    uint256 royaltyAmount
  ) {
    receiver = royaltyAddress[_tokenId];
    royaltyAmount = _salePrice * royaltyPermille / 1000;
  }
}
