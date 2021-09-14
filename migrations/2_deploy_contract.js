const Contract = artifacts.require("ERC2981");

module.exports = async function(deployer) {
  await deployer.deploy(Contract);
}
