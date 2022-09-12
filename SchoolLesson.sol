// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

import "./SchoolLib.sol";
import "./ISchoolLesson.sol";

contract SchoolLesson is ISchoolLesson {
    address public teacher;
    address public school;
    string public lesson;
    mapping(bytes32 => SchoolLib.MarkInfo) private _marks;
    string[] private _reviews;

    constructor(address school_, string memory lesson_) {
        lesson = lesson_;
        school = school_;
    }

    modifier onlyTeacher() {
        require(teacher == msg.sender,
                "You do not have permission to run this function. Only teacher allowed.");
        _;
    }

    modifier onlySchool() {
        require(school == msg.sender,
                "You do not have permission to run this function. Only school allowed.");
        _;
    }


    function showMark(string memory idStudent_) external view override returns (SchoolLib.MarkInfo memory)
    {
        bytes32 hashIdStudent = keccak256(abi.encodePacked(idStudent_));
        SchoolLib.MarkInfo memory markStudent = _marks[hashIdStudent];
        return markStudent;
    }

    function examReviewRequest(string memory idStudent_) public {
        _reviews.push(idStudent_);
        emit ExamReview(idStudent_);
    }

    function rateStudent(string memory idStudent_, uint256 mark_) external override onlyTeacher
    {
        bytes32 hashIdStudent = keccak256(abi.encodePacked(idStudent_));
        if (_marks[hashIdStudent].timestamp == 0) {
            _marks[hashIdStudent] = SchoolLib.MarkInfo(mark_, 0, block.timestamp, 0, msg.sender, address(0), school);
        } else {
            _marks[hashIdStudent].markReview = mark_;
            _marks[hashIdStudent].timestampReview = block.timestamp;
            _marks[hashIdStudent].teacherReview = msg.sender;
        }
        emit StudentEvaluated(hashIdStudent);
    }

    function viewingStudentsRequestedExamReview()external view override onlyTeacher returns (string[] memory)
    {
        return _reviews;
    }

    function setTeacher(address teacher_) external override onlySchool {
        emit TeacherChanged(teacher, teacher_);
        teacher = teacher_;
    }

    function removeTeacher() external override onlySchool {
        emit TeacherChanged(teacher, address(0));
        teacher = address(0);
    }

    function setSchool(address school_) external onlySchool {
        emit SchoolWalletChanged(school, school_);
        school = school_;
    }
}