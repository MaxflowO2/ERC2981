/*     +%%#-                           ##.        =+.    .+#%#+:       *%%#:    .**+-      =+
 *   .%@@*#*:                          @@: *%-   #%*=  .*@@=.  =%.   .%@@*%*   +@@=+=%   .%##
 *  .%@@- -=+                         *@% :@@-  #@=#  -@@*     +@-  :@@@: ==* -%%. ***   #@=*
 *  %@@:  -.*  :.                    +@@-.#@#  =@%#.   :.     -@*  :@@@.  -:# .%. *@#   *@#*
 * *%@-   +++ +@#.-- .*%*. .#@@*@#  %@@%*#@@: .@@=-.         -%-   #%@:   +*-   =*@*   -@%=:
 * @@%   =##  +@@#-..%%:%.-@@=-@@+  ..   +@%  #@#*+@:      .*=     @@%   =#*   -*. +#. %@#+*@
 * @@#  +@*   #@#  +@@. -+@@+#*@% =#:    #@= :@@-.%#      -=.  :   @@# .*@*  =@=  :*@:=@@-:@+
 * -#%+@#-  :@#@@+%++@*@*:=%+..%%#=      *@  *@++##.    =%@%@%%#-  =#%+@#-   :*+**+=: %%++%*
 *
 * @title: Llamas.sol
 * @author: Max Flow O2 -> @MaxFlowO2 on bird app/GitHub
 * @notice: Solidity for Llama/BAYC Mint engine, does Provenance for Metadata/Images
 * Source: https://etherscan.io/address/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d#code
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ILlamas.sol";
import "./IMAX721.sol";
import "../lib/PsuedoRand.sol";

abstract contract Llamas is IMAX721, ILlamas {

  using PsuedoRand for PsuedoRand.Engine;

  PsuedoRand.Engine private llamas;

  // @dev this is for any team mint that happens, must be included in mint...
  function _oneTeamMint()
    internal {
    llamas.battersUp();
    llamas.battersUpTeam();
  }

  // @dev this is for any mint outside of a team mint, must be included in mint...
  function _oneRegularMint()
    internal {
    llamas.battersUp();
  }

  // @dev this will set the boolean for minter status
  // @param toggle: bool for enabled or not
  function _setStatus(
    bool toggle
  ) internal {
    llamas.setStatus(toggle);
  }

  // @dev this will set the minter fees
  // @param number: uint for fees in wei.
  function _setMintFees(
    uint number
  ) internal {
    llamas.setFees(number);
  }

  // @dev this will set the minter capacity of team mints
  // @param number: uint for maximum, 10,000 for 10k i.e.
  function _setMintLimitTeam(
    uint number
  ) internal {
    llamas.setMaxTeam(number);
  }

  // @dev this will set the minter capacity
  // @param number: uint for maximum, 10,000 for 10k i.e.
  // @notice: This is a prereq to _setPovenance(string, string)
  function _setMintLimit(
    uint number
  ) internal {
    llamas.setMaxCap(number);
  }

  // @dev this will set the Provenance Hashes
  // @param string memory img - Provenance Hash of images in sequence
  // @param string memory json - Provenance Hash of metadata in sequence
  // @notice: This will set the start number as well, make sure to set MaxCap
  //  also can be a hyperlink... sha3... ipfs.. whatever.
  function _setProvenance(
    string memory img
  , string memory json
  ) internal {
    llamas.setProvJSON(json);
    llamas.setProvIMG(img);
    llamas.setStartNumber();
  }

  // @dev will return status of Minter
  // @return - bool of active or not
  function minterStatus()
    external
    view
    override(IMAX721)
    returns (bool) {
    return llamas.status;
  }

  // @dev will return minting fees
  // @return - uint of mint costs in wei
  function minterFees()
    external
    view
    override(IMAX721)
    returns (uint) {
    return llamas.mintFee;
  }

  // @dev will return maximum mint capacity
  // @return - uint of maximum mints allowed
  function minterMaximumCapacity()
    external
    view
    override(IMAX721)
    returns (uint) {
    return llamas.maxCapacity;
  }

  // @dev will return maximum "team minting" capacity
  // @return - uint of maximum airdrops or team mints allowed
  function minterMaximumTeamMints()
    external
    view
    override(IMAX721)
    returns (uint) {
    return llamas.maxTeamMints;
  }

  // @dev will return "team mints" left
  // @return - uint of remaing airdrops or team mints
  function minterTeamMintsRemaining()
    external
    view
    override(IMAX721)
    returns (uint) {
    return llamas.maxTeamMints - llamas.currentTeam.current();
  }

  // @dev will return "team mints" count
  // @return - uint of airdrops or team mints done
  function minterTeamMintsCount()
    external
    view
    override(IMAX721)
    returns (uint) {
    return llamas.currentTeam.current();
  }

  // @dev: will return total supply for mint
  // @return: uint for this mint
  function totalSupply()
    external
    view
    override(IMAX721)
    returns (uint256) {
    return llamas.currentMinted;
  }

  // @dev: will return Provenance hash of images
  // @return: string memory of the Images Hash (sha256)
  function RevealProvenanceImages() 
    external 
    view 
    override(ILlamas) 
    returns (string memory) {
    return llamas.ProvenanceIMG;
  }

  // @dev: will return Provenance hash of metadata
  // @return: string memory of the Metadata Hash (sha256)
  function RevealProvenanceJSON()
    external
    view
    override(ILlamas)
    returns (string memory) {
    return llamas.ProvenanceJSON;
  }

  // @dev: will return starting number for mint
  // @return: uint of the start number
  function RevealStartNumber()
    external
    view
    override(ILlamas)
    returns (uint256) {
    return llamas.startNumber;
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
      interfaceId == type(ILlamas).interfaceId  ||
      interfaceId == type(IMAX721).interfaceId  ||
      super.supportsInterface(interfaceId)
    );
  }
}
