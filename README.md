# ERC-2981 Royalties:

### Basing EIP-2981 into ERC-2981
After using https://eips.ethereum.org/EIPS/eip-2981 as the final standard, I have taken IERC2981.sol and forged this into ERC2981.sol and ERC2981Collection.sol

#### ERC2981.sol (for public minters)
By using a Struct we are attempting to use closer to a 21k gas fee (full 2^256 slot).

mappedRoyalties.receiver - address for royalties<br>
mappedRoyalties.percentage - uint for pecentage (yes can change to permille)<br>

mapping(uint256 => mappedRoyalties) royalty - mapping per tokenId

_setRoyalties(uint, address, uint) internal - sets the mapping

royaltyInfo(uint, address) - override of IERC2981.sol
* returns mappedRoyalties.receiver
* returns value to be sent from sale

#### ERC2981Collection.sol (for public minters)
Designed more for x amount of minters for an artist collection.<br>
By using 2 variables, royaltyAddress and royaltyPercent more gas intensive, but should be a one time setting.

_setRoyalties(address, uint) internal - sets the two variable

royaltyInfo(uint, address) - override of IERC2981.sol
* returns royaltyAddress
* returns value to be sent from sale

### Requirements: (for testing)
1. Node.js - Latest 
2. NPM - Latest
3. Truffle - Latest (npm install -g truffle)
4. hdwallet-provider - Latest (npm install -g @truffle/hdwallet-provider)
5. OpenZeppelin/contracts (npm install -g @openzeppelin/contracts)
6. truffle-plugin-verify - Latest (npm install -g truffle-plugin-verify)
7. Infura API-Key
8. Ftmscan API-Key 
9. mnemonic for generation of Private Key
10. .env setup:
  * MNEMONIC=""
  * INFURA_API_KEY=
  * FTMSCAN_API_KEY=
11. dotenv - Latest (npm install -g dotenv)
12. git - Latest (if you plan on developing with us)
13. create .gitignore
  * add .env

### Currently under testing phase
