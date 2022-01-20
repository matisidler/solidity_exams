//SPDX-License-Identifier: MIT
pragma solidity >0.7.0;
pragma experimental ABIEncoderV2;

/*
STUDENT / ID / GRADE
Juan    12345   10
Pepe    54321   8
Maria   78945   2
Marta   45698   3
Rodrigo 48972   7
*/

contract grades{

    //teacher address
    address public teacher;

    constructor() {
        //msg.sender in the constructor = the address who deployed the contract
        teacher = msg.sender;
    }
    //mapping to relate the identity hash of the student with their exam grade.
    mapping (bytes32 => uint) gradesMap;

    //slice of students who are requesting for exams reviews. we will store the ID of the student.
    string [] reviewings;
    //events
    event evaluated_student(bytes32);
    event review_event(string);
    
    //function to evaluate students
    function evaluate(string memory  _idStudent, uint _grade) public onlyTeacher(msg.sender){
        //student identity hash
        bytes32 hash_idStudent = keccak256(abi.encodePacked(_idStudent));
        //add the grade to the gradesMap
        gradesMap[hash_idStudent] = _grade;
        //emit the evaluated student event
        emit evaluated_student(hash_idStudent);
    }
    //only the teacher will be able to execute functions with this modifier
    modifier onlyTeacher(address sender){
        require(sender == teacher, "you don't have permissions to execute this function");
        _;
    }

    //view grades
    function ViewGrades(string memory _idStudent) public view returns(uint){
        bytes32 hashStudent = keccak256(abi.encodePacked(_idStudent));
        require(gradesMap[hashStudent] != 0, "student didn't find");
        return gradesMap[hashStudent];
    }

    //function to ask for a exam review
    function Review(string memory _idStudent) public{
        //store the student identity in the reviewings array
        reviewings.push(_idStudent);
        emit review_event(_idStudent);
    }

    //view the students who asked for an exam review
    function ViewReviews() public view onlyTeacher(msg.sender) returns(string [] memory){
        return reviewings;
    }






}