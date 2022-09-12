//SPDX-License-Identifier: MIT
pragma solidity 0.8.16.0;

import "./SchoolManagement.sol";

contract MinistryEducation {

    address public ministry;
    mapping(string => SchoolManagement) public mapSchools;
    string[] public schoolNames;

    event MinistryChanged(address old_, address new_);
    event SchoolAdded(string schoolName_);

    constructor() {
        ministry = msg.sender;
    }


    modifier onlyMinistry() {
        require(ministry == msg.sender,
            "You do not have permission to run this function. Only ministry allowed.");
        _;
    }

    function setMinistry(address ministry_) external onlyMinistry {
        emit MinistryChanged(ministry, ministry_);
        ministry = ministry_;
    }

    function addSchool(address schoolManagementWallet_,string memory schoolName_) external onlyMinistry {
        SchoolManagement school = new SchoolManagement(schoolManagementWallet_, schoolName_);
        mapSchools[schoolName_] = school;
        schoolNames.push(schoolName_);
        emit SchoolAdded(schoolName_);
    }
}
