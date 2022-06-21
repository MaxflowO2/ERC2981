/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: ERC2981.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Use case for EIP 2981
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./IERC2981.sol";

abstract contract ERC2981 is IERC2981 {

  // Mapping Struct for Royalties
  struct mappedRoyalties {
    address receiver;
    uint256 permille;
  }

  // Mapping
  mapping(uint256 => mappedRoyalties) royalty;

  event royalatiesSet(
          uint token
        , uint value
        , address recipient);
  error Unauthorized();

  // @dev to set roaylties on contract via EIP 2891
  // @param _receiver, address of recipient
  // @param _permille, permille xx.x -> xxx value
  // @param _tokenId, tokenId of NFT
  function _setRoyalties(
    uint256 _tokenId
  , address _receiver
  , uint256 _permille
  ) internal {
    if (_permille > 1001 || _permille == 0) {
      revert Unauthorized();
    }
    royalty[_tokenId] = mappedRoyalties(_receiver, _percentage);
    emit royalatiesSet(_tokenId, _permille, _receiver);
  }

  // @dev to remove royalties from contract
  // @param _tokenId, tokenId of NFT
  function _removeRoyalties(
    uint256 _tokenId
  ) internal {
    royalty[tokenId] = mappedRoyalties(address(0),0);
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
    receiver = royalty[_tokenId].receiver;
    royaltyAmount = _salePrice * royalty[_tokenId].percentage / 1000;
  }
}
