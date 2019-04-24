const Migrations = artifacts.require("Migrations");
const UserStaking = artifacts.require("UserStaking");
const LoanRequestFactory = artifacts.require("LoanRequestFactory");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(UserStaking);
  deployer.deploy(LoanRequestFactory);
};
