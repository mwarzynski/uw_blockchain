pragma solidity ^0.4.23;

contract Course {
    bytes32 public courseName;
    address public teacher;
    address[] public students;
    mapping(address => uint32) points;
    
    constructor(bytes32 _name, address[] _students) public {
        teacher = msg.sender;
        courseName = _name;
        students = _students;
    }
    
    event StudentResult(address student, uint32 points, uint date);
    
    modifier onlyTeacher() {
        require(msg.sender == teacher);
        _;
    }
    
    function containsStudent(address _student) private view returns (bool) {
        for (uint i=0; i < students.length; i++) {
            if (students[i] == _student) {
                return true;
            }
        }
        return false;
    }
    
    function addPoints(address _student, uint32 _points) public onlyTeacher {
        if (!containsStudent(_student)) {
            return;
        }
        points[_student] += _points;
        emit StudentResult(_student, _points, now);
    }
    
    function getMark(address _student) public view returns (uint8) {
        uint32 studentPoints = points[_student];
        if (studentPoints < 50) { return 20; }
        if (studentPoints < 60) { return 30; }
        if (studentPoints < 70) { return 35; }
        if (studentPoints < 80) { return 40; }
        if (studentPoints < 90) { return 45; }
        return 50;
    }
}

