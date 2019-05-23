pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "./PermissionsLib.sol";
import "../crowdloan/StudentLoanCrowdfundFactory.sol";

// @notice Registry for Enable core contract addresses. Modelled after Dharma ContractRegistry.
contract EnableContractRegistry is Ownable {

    event ContractAddressUpdated(
        ContractType indexed contractType,
        address indexed oldAddress,
        address indexed newAddress
    );

    enum ContractType {
        PermissionsLib,
        StudentLoanCrowdfundFactory
    }

    PermissionsLib public permissionsLib;
    StudentLoanCrowdfundFactory public studentLoanCrowdfundFactory;

    constructor(
        address _permissionsLib,
        address _studentLoanCrowdfundFactory
    ) public {
        permissionsLib = PermissionsLib(_permissionsLib);
        studentLoanCrowdfundFactory = StudentLoanCrowdfundFactory(_studentLoanCrowdfundFactory);
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

        ContractAddressUpdated(contractType, oldAddress, newAddress);
    }

    function _validateNewAddress(address newAddress, address oldAddress) internal pure {
        require(newAddress != address(0)); // new address cannot be null address.
        require(newAddress != oldAddress); // new address cannot be existing address.
    }
}