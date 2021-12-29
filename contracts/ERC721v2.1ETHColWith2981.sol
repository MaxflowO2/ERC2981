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
 *
 * Purpose: Chain ID #1-5 OpenSea compliant contracts with ERC2981 compliance
 * Gas Estimate as-is: 3,133,917
 *
 * Rewritten to v2.1 standards (DeveloperV2 and ReentrancyGuard)
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./access/DeveloperV2.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC2981Collection.sol";
import "./interface/IMAX721.sol";
import "./modules/PaymentSplitter.sol";
import "./modules/BAYC.sol";
import "./modules/ContractURI.sol";

contract ERC721v2d1ETHCollection is ERC721, ERC2981Collection, BAYC, ContractURI, IMAX721, ERC165Storage, ReentrancyGuard, PaymentSplitter, DeveloperV2, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  Counters.Counter private _teamMintCounter;
  uint256 private mintStartID;
  uint256 private mintFees;
  uint256 private mintSize;
  uint256 private teamMintSize;
  string private base;
  bool private enableMinter;
  bool private lockedProvenance;
  bool private lockedPayees;

  event UpdatedBaseURI(string _old, string _new);
  event UpdatedMintFees(uint256 _old, uint256 _new);
  event UpdatedMintSize(uint _old, uint _new);
  event UpdatedMintStatus(bool _old, bool _new);
  event UpdatedRoyalties(address newRoyaltyAddress, uint256 newPercentage);
  event UpdatedTeamMintSize(uint _old, uint _new);
  event ProvenanceLocked(bool _status);
  event PayeesLocked(bool _status);

  // bytes4 constants for ERC165
  bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
  bytes4 private constant _INTERFACE_ID_IERC2981 = 0x2a55205a;
  bytes4 private constant _INTERFACE_ID_IBAYC = 0xdee68dd1;
  bytes4 private constant _INTERFACE_ID_IContractURI = 0xe8a3d485;
  bytes4 private constant _INTERFACE_ID_IMAX721 = 0x29499a25;
  bytes4 private constant _INTERFACE_ID_DeveloperV2 = 0xcb49d479;
  bytes4 private constant _INTERFACE_ID_PaymentSplitter = 0x4a7f18f2;

  constructor() ERC721("ERC", "721") {

    // ECR165 Interfaces Supported
    _registerInterface(_INTERFACE_ID_ERC721);
    _registerInterface(_INTERFACE_ID_IERC2981);
    _registerInterface(_INTERFACE_ID_IBAYC);
    _registerInterface(_INTERFACE_ID_IContractURI);
    _registerInterface(_INTERFACE_ID_IMAX721);
    _registerInterface(_INTERFACE_ID_DeveloperV2);
    _registerInterface(_INTERFACE_ID_PaymentSplitter);
  }

/***
 *    ███╗   ███╗██╗███╗   ██╗████████╗
 *    ████╗ ████║██║████╗  ██║╚══██╔══╝
 *    ██╔████╔██║██║██╔██╗ ██║   ██║   
 *    ██║╚██╔╝██║██║██║╚██╗██║   ██║   
 *    ██║ ╚═╝ ██║██║██║ ╚████║   ██║   
 *    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   
 */

  function publicMint(uint256 amount) public payable nonReentrant(){
    require(lockedProvenance, "Set Provenance hashes");
    require(enableMinter, "Minter not active");
    require(msg.value == mintFees * amount, "Wrong amount of Native Token");
    require(_tokenIdCounter.current() + amount <= mintSize, "Can not mint that many");
    for (uint i = 0; i < amount; i++) {
      _safeMint(msg.sender, mintID());
      _tokenIdCounter.increment();
    }
  }

  function teamMint(address _address) public onlyOwner {
    require(lockedProvenance, "Set Provenance hashes");
    require(teamMintSize != 0, "Team minting not enabled");
    require(_tokenIdCounter.current() < mintSize, "Can not mint that many");
    require(_teamMintCounter.current() < teamMintSize, "Can not team mint anymore");
    _safeMint(_address, mintID());
    _tokenIdCounter.increment();
    _teamMintCounter.increment();
  }

  // @notice this shifts the _tokenIdCounter to proper mint number
  function mintID() internal view returns (uint256) {
    return (mintStartID + _tokenIdCounter.current()) % mintSize;
  }

  // Function to receive ether, msg.data must be empty
  receive() external payable {
    // From PaymentSplitter.sol
    emit PaymentReceived(msg.sender, msg.value);
  }

  // Function to receive ether, msg.data is not empty
  fallback() external payable {
    // From PaymentSplitter.sol
    emit PaymentReceived(msg.sender, msg.value);
  }

  function getBalance() external view returns (uint) {
    return address(this).balance;
  }

/***
 *     ██████╗ ██╗    ██╗███╗   ██╗███████╗██████╗ 
 *    ██╔═══██╗██║    ██║████╗  ██║██╔════╝██╔══██╗
 *    ██║   ██║██║ █╗ ██║██╔██╗ ██║█████╗  ██████╔╝
 *    ██║   ██║██║███╗██║██║╚██╗██║██╔══╝  ██╔══██╗
 *    ╚██████╔╝╚███╔███╔╝██║ ╚████║███████╗██║  ██║
 *     ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
 * This section will have all the internals set to onlyOwner
 */

  // @notice this will use internal functions to set EIP 2981
  // found in IERC2981.sol and used by ERC2981Collections.sol
  function setRoyaltyInfo(address _royaltyAddress, uint256 _percentage) public onlyOwner {
    _setRoyalties(_royaltyAddress, _percentage);
    emit UpdatedRoyalties(_royaltyAddress, _percentage);
  }

  // @notice this will set the fees required to mint using
  // publicMint(), must enter in wei. So 1 ETH = 10**18.
  function setMintFees(uint256 _newFee) public onlyOwner {
    uint256 oldFee = mintFees;
    mintFees = _newFee;
    emit UpdatedMintFees(oldFee, mintFees);
  }

  // @notice this will enable publicMint()
  function enableMinting() public onlyOwner {
    bool old = enableMinter;
    enableMinter = true;
    emit UpdatedMintStatus(old, enableMinter);
  }

  // @notice this will disable publicMint()
  function disableMinting() public onlyOwner {
    bool old = enableMinter;
    enableMinter = false;
    emit UpdatedMintStatus(old, enableMinter);
  }

/***
 *    ██████╗ ███████╗██╗   ██╗
 *    ██╔══██╗██╔════╝██║   ██║
 *    ██║  ██║█████╗  ██║   ██║
 *    ██║  ██║██╔══╝  ╚██╗ ██╔╝
 *    ██████╔╝███████╗ ╚████╔╝ 
 *    ╚═════╝ ╚══════╝  ╚═══╝  
 * This section will have all the internals set to onlyDev
 * also contains all overrides required for funtionality
 */

  // @notice will update _baseURI() by onlyDev role
  function setBaseURI(string memory _base) public onlyDev {
    string memory old = base;
    base = _base;
    emit UpdatedBaseURI(old, base);
  }

  // @notice will set the ContractURI for OpenSea
  function setContractURI(string memory _contractURI) public onlyDev {
    _setContractURI(_contractURI);
  }

  // @notice will set "team minting" by onlyDev role
  function setTeamMinting(uint256 _amount) public onlyDev {
    uint256 old = teamMintSize;
    teamMintSize = _amount;
    emit UpdatedTeamMintSize(old, teamMintSize);
  }

  // @notice will set mint size by onlyDev role
  function setMintSize(uint256 _amount) public onlyDev {
    uint256 old = mintSize;
    mintSize = _amount;
    emit UpdatedMintSize(old, mintSize);
  }

  // @notice this will set the Providence Hashes
  // This will also set the starting order as well!
  // Only one shot to do this, otherwise it shows as invalid
  function setProvidence(string memory _images, string memory _json) public onlyDev {
    require(mintSize != 0 && !lockedProvenance, "Prerequisites not met");
    // This is the initial setting
    _setProvenanceImages(_images);
    _setProvenanceJSON(_json);
    // Now to psuedo-random the starting number
    // Chainlink VRF not really needed for this at all
    // Your API should be a random before this step!
    mintStartID = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _images, _json, block.difficulty))) % mintSize;
    _setStartNumber(mintStartID);
    // @notice Locks sequence
    lockedProvenance = true;
  }

  // @notice this will set the reveal timestamp
  // This is more for your API and not on chain...
  function setRevealTimestamp(uint256 _time) public onlyDev {
    _setRevealTimestamp(_time);
  }

  // @notice will add an address to PaymentSplitter by onlyDev role
  function addPayee(address addy, uint256 shares) public onlyDev {
    _addPayee(addy, shares);
  }

  // @notice function useful for accidental ETH transfers to contract (to user address)
  // wraps _user in payable to fix address -> address payable
  function sweepEthToAddress(address _user, uint256 _amount) public onlyDev {
    payable(_user).transfer(_amount);
  }

  ///
  /// Developer, these are the overrides
  ///

  // @notice solidity required override for _baseURI()
  function _baseURI() internal view override returns (string memory) {
    return base;
  }

  // @notice solidity required override for supportsInterface(bytes4)
  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC165Storage, IERC165) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  // @notice will return status of Minter
  function minterStatus() external view override(IMAX721) returns (bool) {
    return enableMinter;
  }

  // @notice will return minting fees
  function minterFees() external view override(IMAX721) returns (uint256) {
    return mintFees;
  }

  // @notice will return maximum mint capacity
  function minterMaximumCapacity() external view override(IMAX721) returns (uint256) {
    return mintSize;
  }

  // @notice will return maximum "team minting" capacity
  function minterMaximumTeamMints() external view override(IMAX721) returns (uint256) {
    return teamMintSize;
  }
  // @notice will return "team mints" left
  function minterTeamMintsRemaining() external view override(IMAX721) returns (uint256) {
    return teamMintSize - _teamMintCounter.current();
  }

  // @notice will return "team mints" count
  function minterTeamMintsCount() external view override(IMAX721) returns (uint256) {
    return _teamMintCounter.current();
  }

  // @notice will return current token count
  function totalSupply() external view override(IMAX721) returns (uint256) {
    return _tokenIdCounter.current();
  }
}
