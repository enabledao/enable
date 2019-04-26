require('dotenv').config()

const Migrations = artifacts.require("Migrations");
const UserStaking = artifacts.require("UserStaking");
const LoanRequestFactory = artifacts.require("LoanRequestFactory");

// Should add some way to get addresses based on what network you're on
const bloomAccountsLogicAddress = process.env.BLOOM_ACCOUNTS_LOGIC_RINKEBY;
const bloomAttestationogicAddress = process.env.BLOOM_ATTESTATION_LOGIC_RINKEBY;

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(UserStaking, bloomAccountsLogicAddress);
  deployer.deploy(LoanRequestFactory);
};
