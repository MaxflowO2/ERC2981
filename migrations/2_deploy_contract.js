const Contract = artifacts.require("ERC721v2Collection");
//const Contract2 = artifacts.require("ERC721v2CollectionWhitelist");

module.exports = async function(deployer) {
  await deployer.deploy(Contract);
//  await deployer.deploy(Contract2);
}
