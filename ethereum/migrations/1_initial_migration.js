const NULL_ADDRESS = "0x0000000000000000000000000000000000000000";
const Migrations = artifacts.require("Migrations");

// System Core
const UserStaking = artifacts.require("UserStaking");
const PermissionsLib = artifacts.require("PermissionsLib");
const EnableContractRegistry = artifacts.require("EnableContractRegistry");
const EnableTokenRegistry = artifacts.require("EnableTokenRegistry");

// Loans Core
const DebtTokenFactory = artifacts.require("DebtTokenFactory");

// Student Loans
const StudentLoanTermsContract = artifacts.require("StudentLoanTermsContract");
const StudentLoanTermsStorage = artifacts.require("StudentLoanTermsStorage");
const StudentLoanCrowdfundFactory = artifacts.require("StudentLoanCrowdfundFactory");

module.exports = async function(deployer) {
  await deployer.deploy(Migrations);
  const enableRegistry = await deployer.deploy(EnableContractRegistry);
  console.log(enableRegistry.address);

  const userStaking = await deployer.deploy(UserStaking);
  const permissionsLib = await deployer.deploy(PermissionsLib);
  const permissionsLib = await deployer.deploy(EnableTokenRegistry);

  const debtTokenFactory = await deployer.deploy(DebtTokenFactory, enableRegistry.address);
  // const studentLoanTermsContract = await deployer.deploy(StudentLoanTermsContract, enableRegistry.address);
  const studentLoanTermsStorage = await deployer.deploy(StudentLoanTermsStorage, enableRegistry.address);
  const studentLoanCrowdfundFactory = await deployer.deploy(StudentLoanCrowdfundFactory, enableRegistry.address);

  await enableRegistry.initialize(
    permissionsLib.address,
    userStaking.address,
    NULL_ADDRESS,
    debtTokenFactory.address,
    studentLoanCrowdfundFactory.address,
    studentLoanTermsStorage.address,
  );

  const result = await enableRegistry.permissionsLib();
  console.log(result);
};
