// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./SchoolLesson.sol";

contract SchoolManagement {

    address public school;
    string public schoolName;
    mapping(string => address) public _mapAddrLessons;
    string[] public _lessons;
    mapping(bytes32 => string) private _mapCertficates;
    address public ministryContract;

    event SchoolWalletChanged(address old_, address new_);
    event LessonAdded(string lesson_, address lessonContract_);

    constructor(address school_, string memory schoolName_) {
        school = school_;
        schoolName = schoolName_;
        ministryContract = msg.sender;
    }

    modifier onlySchool() {
        require(school == msg.sender,
                "You do not have permission to run this function. Only school allowed.");
        _;
    }

    function setSchool(address school_) external onlySchool {
        emit SchoolWalletChanged(school, school_);
        school = school_;
    }


    function addLesson(string memory lessonName_) external onlySchool {
        address addrContractLesson = address(new SchoolLesson(school, lessonName_));
        _mapAddrLessons[lessonName_] = addrContractLesson;
        _lessons.push(lessonName_);
        emit LessonAdded(lessonName_, addrContractLesson);
    }

    function addCertification(bytes32 studentHash_, string memory ipfsCIDCertificate_) external onlySchool {
        _mapCertficates[studentHash_] = ipfsCIDCertificate_;
    }

    function getCertification(bytes32 studentHash_) external view returns (string memory ipfsCID)
    {
        ipfsCID = _mapCertficates[studentHash_];
    }
}
