const Contract = artifacts.require("ERC721v2Collection");
const ContractEth = artifacts.require("ERC721v2ETHCollection");
const Contract2 = artifacts.require("ERC721v2CollectionWhitelist");
const ContractEth2 = artifacts.require("ERC721v2ETHCollectionWhitelist");
const ContractWLNo2981 = artifacts.require("ERC721v2ETHCollectionWhitelistNoERC2981");
const ContractNo2981 = artifacts.require("ERC721v2ETHCollectionNoERC2981");

module.exports = async function(deployer) {
  await deployer.deploy(ContractEth);
  await deployer.deploy(ContractEth2);
  await deployer.deploy(Contract);
  await deployer.deploy(Contract2);
  await deployer.deploy(ContractWLNo2981);
  await deployer.deploy(ContractNo2981);
}
