/***
 *    ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     
 *    ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝     
 *    ██████╔╝██║   ██║██████╔╝██║     ██║██║          
 *    ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║          
 *    ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗     
 *    ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     
 *                                                     
 *    ███╗   ███╗██╗███╗   ██╗████████╗███████╗██████╗ 
 *    ████╗ ████║██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
 *    ██╔████╔██║██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
 *    ██║╚██╔╝██║██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
 *    ██║ ╚═╝ ██║██║██║ ╚████║   ██║   ███████╗██║  ██║
 *    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
 * Written by MaxFlowO2, Senior Developer and Partner of G&M² Labs
 * Follow me on https://github.com/MaxflowO2 or Twitter @MaxFlowO2
 * email: cryptobymaxflowO2@gmail.com
 *
 * Gas estimate: 2,534,770
 *
 * Rewritten to v2.1 standards (DeveloperV2 and ReentrancyGuard)
 * Rewritten to v2.1.1 standards, removal of ERC165Storage, msg.sender => _msgSender()
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./access/DeveloperV2.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC2981.sol";
import "./modules/PaymentSplitter.sol";

contract PublicMinter is ERC721, ERC721URIStorage, ERC2981, ReentrancyGuard, PaymentSplitter, DeveloperV2, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  uint256 private mintFees;
  bool private enableMinter;
  mapping(uint => address) creators;

  event UpdatedMintFees(uint256 _old, uint256 _new);
  event UpdatedMintStatus(bool _old, bool _new);
  event DevSweepETH(address _sentTo, uint256 _amount);

  constructor() ERC721("ERC", "721") {}

/***
 *    ███╗   ███╗██╗███╗   ██╗████████╗
 *    ████╗ ████║██║████╗  ██║╚══██╔══╝
 *    ██╔████╔██║██║██╔██╗ ██║   ██║   
 *    ██║╚██╔╝██║██║██║╚██╗██║   ██║   
 *    ██║ ╚═╝ ██║██║██║ ╚████║   ██║   
 *    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   
 */

  function publicMint(string memory ipfsHash, uint256 permille) public payable nonReentrant() {
    require(enableMinter, "Minter not active");
    require(msg.value == mintFees, "Wrong amount of Native Token");
    _safeMint(_msgSender(), _tokenIdCounter.current());
    _setTokenURI(_tokenIdCounter.current(), ipfsHash);
    creators[_tokenIdCounter.current()] =  _msgSender();
    _setRoyalties(_tokenIdCounter.current(), _msgSender(), permille);
    _tokenIdCounter.increment();
  }

  // allows the creator of the token to adjust royalties
  function adjustRoyalties(uint256 _tokenID, address _address, uint256 _permille) public {
    require(_msgSender() == creators[_tokenID], "You are not the creator of this NFT");
    _setRoyalties(_tokenID, _address, _permille);
  }

  // allows the creator of the token to adjust the IPFS hash
  function adjustIPFSHash(uint256 _tokenID, string memory ipfsHash) public {
    require(_msgSender() == creators[_tokenID], "You are not the creator of this NFT");
    _setTokenURI(_tokenID, ipfsHash);
  }

  // Function to receive ether, msg.data must be empty
  receive() external payable {
    // From PaymentSplitter.sol
    emit PaymentReceived(_msgSender(), msg.value);
  }

  // Function to receive ether, msg.data is not empty
  fallback() external payable {
    // From PaymentSplitter.sol
    emit PaymentReceived(_msgSender(), msg.value);
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

  // @notice will add an address to PaymentSplitter by onlyDev role
  function addPayee(address addy, uint256 shares) public onlyDev {
    _addPayee(addy, shares);
  }

  // @notice function useful for accidental ETH transfers to contract (to user address)
  // wraps _user in payable to fix address -> address payable
  function sweepEthToAddress(address _user, uint256 _amount) public onlyDev {
    payable(_user).transfer(_amount);
    emit DevSweepETH(_user, _amount);
  }

  ///
  /// Developer, these are the overrides
  ///

  // @notice solidity required override for supportsInterface(bytes4)
  function supportsInterface(bytes4 interfaceId) public pure override(ERC721, IERC165) returns (bool) {
    return (
      interfaceId == type(IERC721).interfaceId ||
      interfaceId == type(ERC721URIStorage).interfaceId  ||
      interfaceId == type(ERC2981).interfaceId  ||
      interfaceId == type(ReentrancyGuard).interfaceId ||
      interfaceId == type(PaymentSplitter).interfaceId ||
      interfaceId == type(DeveloperV2).interfaceId ||
      interfaceId == type(Ownable).interfaceId
    );
  }

  // @notice will return status of Minter
  function minterStatus() external view returns (bool) {
    return enableMinter;
  }

  // @notice will return minting fees
  function minterFees() external view returns (uint256) {
    return mintFees;
  }

  // @notice will return current token count
  function totalSupply() external view returns (uint256) {
    return _tokenIdCounter.current();
  }

  function _baseURI() internal pure override returns (string memory) {
    return "ipfs://";
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(tokenId);
  }
}
