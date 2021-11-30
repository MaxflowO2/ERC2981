const Contract = artifacts.require("ERC721v2Collection");
const ContractEth = artifacts.require("ERC721v2ETHCollection");
const Contract2 = artifacts.require("ERC721v2CollectionWhitelist");

module.exports = async function(deployer) {
  await deployer.deploy(ContractEth);
//  await deployer.deploy(Contract2);
}
