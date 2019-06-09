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
    // studentLoanTermsContract = await StudentLoanTermsContract.deployed();
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

  describe("StudentLoanCrowdfundFactory", () => {
    it.skip("should emit an event for created", async () => {
        const factoryInstance = await StudentLoanCrowdfundFactory.deployed();
        const creationTransaction = await factoryInstance.createStudentLoanCrowdfund(
          accounts[2],
          accounts[3],
          '1000000000',
          '100',
          5,
          [1,2,3,4,5]
        );
        assert.isTrue(
            creationTransaction && creationTransaction.logs && Boolean(creationTransaction.logs.find( log => log.event === 'LoanRequestCreated')),
            'Creation Log not found'
        )
    });
  })

  describe("Test", async function () {
      it('Do test', function () {
        console.log("Done");
      })
  });

});


// contract("LoanRequest", accounts => {
//
//     it.skip("should emit creation event", async () => {
//         const factoryInstance = await LoanRequestFactory.deployed();
//         await factoryInstance.createLoanRequest(accounts[0])
//     });
//
//     it("should have the parameters that were passed in", async () => {
//         const transactionParameters = {
//           requester: accounts[1],
//           ownershipToken: accounts[1],
//           loanCurrency: accounts[2],
//           principal: '1000000000',
//           interestRate: '100',
//           repayments: '5',
//           repaymentSchedule: ['1','2','3','4','5']
//         }
//
//         const factoryInstance = await LoanRequestFactory.deployed();
//         const creationTransaction = await factoryInstance.createLoanRequest(
//           transactionParameters.ownershipToken,
//           transactionParameters.loanCurrency,
//           transactionParameters.principal,
//           transactionParameters.interestRate,
//           transactionParameters.repayments,
//           transactionParameters.repaymentSchedule,
//           {
//             from: transactionParameters.requester
//           }
//         );
//
//         const LoanRequestCreatedEvent = creationTransaction.logs.find( log => log.event === 'LoanRequestCreated');
//         Object.keys(transactionParameters).forEach( parameter => {
//           const parsedEventValue = parameter === 'repaymentSchedule' ? LoanRequestCreatedEvent.args[parameter].map( value => value.toString()) : LoanRequestCreatedEvent.args[parameter].toString();
//           assert.deepEqual(parsedEventValue, transactionParameters[parameter], `Invalid ${parameter} value in Event`);
//         });
//
//         const loanContract = await LoanRequest.at(LoanRequestCreatedEvent.args['contractAddress']);
//         const loanRequester = await loanContract.requester.call();
//         assert.equal(loanRequester, transactionParameters.requester, 'Invalid requester set on LoanRequest');
//     });
//
//     it("should credit tokens to user when loan currency tokens are deposited", () => {
//     });
//
//     it("should not credit tokens to user when loan currency tokens are deposited", () => {
//     });
//
//     it("should not credit tokens with insufficient token approval", () => {
//     });
//
//     it("should not allow token withdrawal during crowdsale", () => {
//     });
//
//     it("should allow token withdrawal after crowdsale", () => {
//     });
//
//     it("should allow refund withdrawal on failure to reach cap", () => {
//     });
//
//     it("should not allow refund withdrawal if cap was reached", () => {
//     });
//
//     it("should allow borrower to withdraw funds if cap is reached", () => {
//     });
//
//     it("should not allow borrower to withdraw funds if cap is not reached", () => {
//     });
//
//     it("should handle re-entrancy attempts on buyTokens()", () => {
//     });
// });
