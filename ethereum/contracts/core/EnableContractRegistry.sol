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
     // System Core
    PermissionsLib public permissionsLib;
    UserStaking public userStaking;
    
    // Loans Core
    DebtTokenFactory public debtTokenFactory;
    
    // Student Loans
    StudentLoanCrowdfundFactory public studentLoanCrowdfundFactory;
    StudentLoanTermsStorage public studentLoanTermsStorage;

    bool public initialized;

    event ContractAddressInitialized(
        ContractType indexed contractType,
        address indexed newAddress
    );

    event ContractAddressUpdated(
        ContractType indexed contractType,
        address indexed oldAddress,
        address indexed newAddress
    );

    enum ContractType {
        PermissionsLib,
        UserStaking,
        DebtTokenFactory,
        StudentLoanCrowdfundFactory,
        StudentLoanTermsStorage
    }
   
    function initialize(
        address _permissionsLib,
        address _userStaking,
        address _debtTokenFactory,
        address _studentLoanCrowdfundFactory,
        address _studentLoanTermsStorage
    ) public onlyOwner {
            require(!initialized, "ALREADY_INITIALIZED");

            permissionsLib = PermissionsLib(_permissionsLib);
            userStaking = UserStaking(_userStaking);

            debtTokenFactory = DebtTokenFactory(_debtTokenFactory);

            studentLoanCrowdfundFactory = StudentLoanCrowdfundFactory(_studentLoanCrowdfundFactory);
            studentLoanTermsStorage = StudentLoanTermsStorage(_studentLoanTermsStorage);

            emit ContractAddressInitialized(ContractType.PermissionsLib, _permissionsLib);
            emit ContractAddressInitialized(ContractType.UserStaking, _userStaking);

            emit ContractAddressInitialized(ContractType.DebtTokenFactory, _debtTokenFactory);

            emit ContractAddressInitialized(ContractType.StudentLoanCrowdfundFactory, _studentLoanCrowdfundFactory);
            emit ContractAddressInitialized(ContractType.StudentLoanTermsStorage, _studentLoanTermsStorage);

            initialized = true;
    }

    //TODO: Decide what's updatable and add here.
    function updateAddress(ContractType contractType, address newAddress) public onlyOwner {
        address oldAddress;

        if (contractType == ContractType.PermissionsLib) {
            oldAddress = address(permissionsLib);
            _validateNewAddress(newAddress, oldAddress);
            permissionsLib = PermissionsLib(newAddress);
        } else if (contractType == ContractType.UserStaking) {
            _validateNewAddress(newAddress, address(userStaking));
            userStaking = UserStaking(newAddress);
        } else if (contractType == ContractType.DebtTokenFactory) {
            oldAddress = address(debtTokenFactory);
            _validateNewAddress(newAddress, oldAddress);
            debtTokenFactory = DebtTokenFactory(newAddress);
        } else if (contractType == ContractType.StudentLoanCrowdfundFactory) {
            oldAddress = address(studentLoanCrowdfundFactory);
            _validateNewAddress(newAddress, oldAddress);
            studentLoanCrowdfundFactory = StudentLoanCrowdfundFactory(newAddress);
        } else if (contractType == ContractType.StudentLoanTermsStorage) {
            oldAddress = address(studentLoanTermsStorage);
            _validateNewAddress(newAddress, oldAddress);
            studentLoanTermsStorage = StudentLoanTermsStorage(newAddress);
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