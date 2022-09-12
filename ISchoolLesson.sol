// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./SchoolLib.sol";

interface ISchoolLesson {
    event StudentEvaluated(bytes32 hashIdStudent_);
    event ExamReview(string idStudent_);
    event TeacherChanged(address old_, address new_);
    event SchoolWalletChanged(address old_, address new_);

    function showMark(string memory idStudent_) external view returns (SchoolLib.MarkInfo memory);
    function examReviewRequest(string memory idStudent_) external;
    function rateStudent(string memory idStudent_, uint256 mark_) external;
    function viewingStudentsRequestedExamReview() external view returns (string[] memory);
    function setTeacher(address teacher_) external;
    function removeTeacher() external;
    function setSchool(address school_) external;
}