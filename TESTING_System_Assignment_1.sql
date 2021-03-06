DROP DATABASE IF EXISTS TestingSystem2;
CREATE DATABASE TestingSystem2;
USE TestingSystem2;

-- Table1---
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
      DepartmentID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      DepartmentName VARCHAR(50) NOT NULL UNIQUE KEY
      );
      
-- Table2---
DROP TABLE IF EXISTS   `Position`;                  
CREATE TABLE `Position`(
      PositionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      PositionName ENUM('Dev','Test','Scrum Master','PM') NOT NULL UNIQUE KEY
     );
     
-- Table3---
DROP TABLE IF EXISTS Account; 	
CREATE TABLE Account(
		  AccountID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  Email VARCHAR(100	) NOT NULL UNIQUE KEY,
		  Username VARCHAR(	100	) NOT NULL UNIQUE KEY,
		  Fullname VARCHAR(100	) NOT NULL,
		  DepartmentID TINYINT UNSIGNED NOT NULL ,
		  PositionID TINYINT UNSIGNED NOT NULL ,
		  CreateDate DATETIME DEFAULT NOW(),
		  FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
		  FOREIGN KEY(PositionID) REFERENCES `Position`(PositionID)
);

-- Table4---
DROP TABLE IF EXISTS `Group`; 
CREATE TABLE `Group`(
     GroupID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
     GroupName NVARCHAR(50) NOT NULL UNIQUE KEY,
     CreatorID TINYINT UNSIGNED,
     CreateDate DATETIME DEFAULT NOW(),
	FOREIGN KEY(CreatorID)  REFERENCES Account(AccountId) 
);

-- Table5---
DROP TABLE IF EXISTS GroupAccount; 
CREATE TABLE GroupAccount(
    GroupID TINYINT UNSIGNED NOT NULL ,
    AccountID TINYINT UNSIGNED NOT NULL ,
    JoinDate DATETIME DEFAULT NOW(),
	FOREIGN KEY(GroupID) REFERENCES `Group`(GroupID), 
    FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
    PRIMARY KEY (GroupID,AccountID)
);

-- Table6---
DROP TABLE IF EXISTS Typequestion;
CREATE TABLE TypeQuestion(
	TypeID TINYINT UNSIGNED  AUTO_INCREMENT PRIMARY KEY, 
    TypeName ENUM('Essay', 'Multiple-choice')  NOT NULL UNIQUE KEY 
);

-- Table7---
DROP TABLE IF EXISTS Categoryquestion;
CREATE TABLE CategoryQuestion(
	CategoryID    TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    CategoryName VARCHAR(50)
);

-- Table8---
DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
	QuestionID 	SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    Content TEXT NOT NULL, 
    CategoryID TINYINT UNSIGNED NOT NULL, 
    TypeID TINYINT UNSIGNED NOT NULL, 
    CreatorID TINYINT UNSIGNED NOT NULL, 
    CreateDate DATETIME DEFAULT NOW(), 
    FOREIGN KEY(CategoryID)  REFERENCES CategoryQuestion(CategoryID), 
    FOREIGN KEY(TypeID)   REFERENCES TypeQuestion(TypeID), 
    FOREIGN KEY(CreatorID)   REFERENCES Account(AccountId)  
); 

-- Table9---
DROP TABLE IF EXISTS Answer;    
CREATE TABLE Answer(
   AnswerID  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
   Content NVARCHAR(100) NOT NULL, 
   QuestionID SMALLINT UNSIGNED NOT NULL,
   isCorrect BOOLEAN, 
   FOREIGN KEY (QuestionID) REFERENCES Question(Questionid)
);

-- Table10---
DROP TABLE IF EXISTS Exam; 
CREATE TABLE Exam(
    ExamID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `Code` CHAR(10) NOT NULL, 
    Title NVARCHAR(50) NOT NULL, 
    CategoryID TINYINT UNSIGNED NOT NULL,
    Duration TINYINT UNSIGNED NOT NULL,
    CreatorID TINYINT UNSIGNED NOT NULL,
    CreateDate DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID), 
    FOREIGN KEY(CreatorID)  REFERENCES Account(AccountId) 
); 

-- Table11--
DROP TABLE IF EXISTS ExamQuestion; 
CREATE TABLE ExamQuestion(
		ExamID TINYINT UNSIGNED NOT NULL,
		QuestionID SMALLINT UNSIGNED NOT NULL,
		FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID), 
		FOREIGN KEY(ExamID) REFERENCES Exam(ExamID) , 
		PRIMARY KEY (ExamID,QuestionID)     
   );







