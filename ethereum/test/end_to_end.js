// System Core
const UserStaking = artifacts.require("UserStaking");
const PermissionsLib = artifacts.require("PermissionsLib");
const EnableContractRegistry = artifacts.require("EnableContractRegistry");

// Loans Core
const DebtTokenFactory = artifacts.require("DebtTokenFactory");

// Student Loans
const StudentLoanTermsContract = artifacts.require("StudentLoanTermsContract");
const StudentLoanTermsStorage = artifacts.require("StudentLoanTermsStorage");
const StudentLoanCrowdfundFactory = artifacts.require("StudentLoanCrowdfundFactory");

let userStaking;
let permissionsLib;
let enableContractRegistry;
let debtTokenFactory;
let studentLoanTermsContract;
let studentLoanTermsStorage;
let studentLoanCrowdfundFactory;

contract( 'ALL', function (accounts) {
  before(async function () {
    userStaking = await UserStaking.deployed();
    permissionsLib = await PermissionsLib.deployed();
    enableContractRegistry = await EnableContractRegistry.deployed();
    debtTokenFactory = await DebtTokenFactory.deployed();
    studentLoanTermsContract = await StudentLoanTermsContract.deployed();
    studentLoanTermsStorage = await StudentLoanTermsStorage.deployed();
    studentLoanCrowdfundFactory =  await StudentLoanCrowdfundFactory.deployed();

    assert.exists(userStaking.address, "Failed to deploy UserStaking with address");
    assert.exists(permissionsLib.address, "Failed to deploy PermissionsLib with address");
    assert.exists(enableContractRegistry.address, "Failed to deploy EnableContractRegistry with address");
    assert.exists(debtTokenFactory.address, "Failed to deploy DebtTokenFactory with address");
    // assert.exists(studentLoanTermsContract.address, "Failed to deploy StudentLoanTermsContract with address");
    assert.exists(studentLoanTermsStorage.address, "Failed to deploy StudentLoanTermsStorage with address");
    assert.exists(studentLoanCrowdfundFactory.address, "Failed to deploy StudentLoanCrowdfundFactory with address");

    // console.log(studentLoanTermsContract)
  });

  describe("Test", async function () {
      it('Do test', function () {
        console.log("Done");
      })
  });

  // describe("")

});
