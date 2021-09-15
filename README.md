# ERC-2981 Royalties:
### Requirements: (for testing)
1. Node.js - Latest 
2. NPM - Latest
3. Truffle - Latest
4. hdwallet-provider - Latest
5. truffle-plugin-verify - Latest
6. Infura API-Key
7. Etherscan API-Key
8. Bncscan API-Key
9. mnemonic for generation of Private Key
10. .env setup:
  * MNEMONIC=""
  * INFURA_API_KEY=
  * ETHERSCAN_API_KEY=
  * BSCSCAN_API_KEY=
11. dontenv - Latest
12. git - Latest (if you plan on developing with us)
13. create .gitignore
  * add .env

### Basing EIP-2981 into ERC-2981
After using https://eips.ethereum.org/EIPS/eip-2981 as the final standard, I have taken IERC2981.sol and forged this into ERC2981.sol

```mapping(uint256 => address) receiver```
* Sets a mapping that can be called with royaltyInfo(uint256 _tokenId, uint256, _salePrice)
* Set by _setReceiver

```mapping(uint256 => uint256) royaltyPercentage```
* Sets a mapping that can be called with royaltyInfo(uint256 _tokenId, uint256, _salePrice)
* Set by _setRoyaltyPercentage

```bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a```
* Passed the value _INTERFACE_ID_ERC2981 in the constructor under _registerInterface(_INTERFACE_ID_ERC2981)
* Functionality is set with import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol"
* Makes override on supportInterface unneeded

```function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view override(IERC2981) returns (address Receiver, uint256 royaltyAmount) {
  Receiver = receiver[_tokenId];
  royaltyAmount = _salePrice.div(100).mul(royaltyPercentage[_tokenId]);
}```
* This is the mapping being used, per token

This is the cleanest solution I could come up with
