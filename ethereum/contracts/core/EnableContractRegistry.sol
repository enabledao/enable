pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./IEnableContractRegistry.sol";

import "./PermissionsLib.sol";
import "./UserStaking.sol";

import "../loans/DebtTokenFactory.sol";

import "../loans/student-loans/StudentLoanCrowdfundFactory.sol";
import "../loans/student-loans/StudentLoanTermsStorage.sol";

// @notice Registry for Enable core contract addresses. Modelled after Dharma ContractRegistry.
contract EnableContractRegistry is Ownable, IEnableContractRegistry {

    event ContractAddressUpdated(
        ContractType indexed contractType,
        address indexed oldAddress,
        address indexed newAddress
    );

    enum ContractType {
        PermissionsLib,
        StudentLoanCrowdfundFactory
    }
    
    // System Core
    PermissionsLib public permissionsLib;
    
    // Loans Core
    DebtTokenFactory public debtTokenFactory;
    
    // Student Loans
    StudentLoanCrowdfundFactory public studentLoanCrowdfundFactory;
    // StudentLoanTermsContract public studentLoanTermsContract;
    StudentLoanTermsStorage public studentLoanTermsStorage;

    constructor(
        address _permissionsLib,
        address _debtTokenFactory,
        address _studentLoanCrowdfundFactory,
        // address _studentLoanTermsContract,
        address _studentLoanTermsStorage
    ) public {
        permissionsLib = PermissionsLib(_permissionsLib);
        
        debtTokenFactory = DebtTokenFactory(_debtTokenFactory);
        
        studentLoanCrowdfundFactory = StudentLoanCrowdfundFactory(_studentLoanCrowdfundFactory);
        // studentLoanTermsContract = StudentLoanTermsContract(_studentLoanTermsContract);
        studentLoanTermsStorage = StudentLoanTermsStorage(_studentLoanTermsStorage);
    }

    //TODO: Decide what's updatable and add here.
    function updateAddress(ContractType contractType, address newAddress) public onlyOwner {
        address oldAddress;

        if (contractType == ContractType.PermissionsLib) {
            oldAddress = address(permissionsLib);
            _validateNewAddress(newAddress, oldAddress);
            permissionsLib = PermissionsLib(newAddress);
        } else {
            revert();
        }

        emit ContractAddressUpdated(contractType, oldAddress, newAddress);
    }

    function _validateNewAddress(address newAddress, address oldAddress) internal pure {
        require(newAddress != address(0)); // new address cannot be null address.
        require(newAddress != oldAddress); // new address cannot be existing address.
    }
}