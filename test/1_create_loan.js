const LoanRequestFactory = artifacts.require("LoanRequestFactory");

contract("LoanRequestFactory", accounts => {

    it("should create a new loan request contract", () => {
        const factoryInstance = await LoanRequestFactory.deployed();
        await factoryInstance.createLoanRequest.send(accounts[0])
    });

    it("should emit an event for created", () => {
    });
});

contract("LoanRequest", accounts => {

    it("should emit creation event", () => {
        const factoryInstance = await LoanRequestFactory.deployed();
        await factoryInstance.createLoanRequest.send(accounts[0])
    });

    it("should have the parameters that were passed in", () => {
        const factoryInstance = await LoanRequestFactory.deployed();
        await factoryInstance.createLoanRequest.send(accounts[0])
    });

    it("should credit tokens to user when loan currency tokens are deposited", () => {
    });

    it("should not credit tokens to user when loan currency tokens are deposited", () => {
    });

    it("should not credit tokens with insufficient token approval", () => {
    });

    it("should not allow token withdrawal during crowdsale", () => {
    });

    it("should allow token withdrawal after crowdsale", () => {
    });

    it("should allow refund withdrawal on failure to reach cap", () => {
    });

    it("should not allow refund withdrawal if cap was reached", () => {
    });

    it("should allow borrower to withdraw funds if cap is reached", () => {
    });

    it("should not allow borrower to withdraw funds if cap is not reached", () => {
    });

    it("should handle re-entrancy attempts on buyTokens()", () => {
    });
});