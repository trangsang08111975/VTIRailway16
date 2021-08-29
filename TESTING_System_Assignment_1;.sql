DROP DATABASE IF EXISTS TestingSystem1;
CREATE DATABASE TestingSystem1;
USE TestingSystem1;

CREATE TABLE Department(
      DepartmentID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      DepartmentName VARCHAR(50) NOT NULL UNIQUE KEY
      );
DROP DATABASE IF EXISTS   `Position`;                  
CREATE TABLE `Position`(
      PositionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      PositionName ENUM('Dev','Test','Scrum Master','PM') NOT NULL UNIQUE 
     );
DROP TABLE IF EXISTS Account;
CREATE TABLE Account(
		  AccountID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  Email VARCHAR(50) NOT NULL UNIQUE KEY,
		  Username VARCHAR(50) NOT NULL UNIQUE KEY,
		  Fullname VARCHAR(50) NOT NULL,
		  DepartmentID TINYINT UNSIGNED NOT NULL DEFAULT (1),
		  PositionID TINYINT UNSIGNED NOT NULL DEFAULT (1),
		  CreateDate DATETIME DEFAULT NOW(),
		  FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
		  FOREIGN KEY(PositionID) REFERENCES `Position`(PositionID)
);

DROP TABLE IF EXISTS `Group`; 
CREATE TABLE `Group`(
     GroupID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
     GroupName NVARCHAR(50) NOT NULL UNIQUE KEY,
     CreatorID TINYINT UNSIGNED,
     CreateDate DATETIME DEFAULT NOW(),
	FOREIGN KEY(CreatorID)  REFERENCES `Account`(AccountId) 
);
DROP TABLE IF EXISTS GroupAccount; 

CREATE TABLE GroupAccount(
    GroupID TINYINT UNSIGNED NOT NULL ,
    AccountID TINYINT UNSIGNED NOT NULL ,
    JoinDate DATETIME DEFAULT NOW(),
	FOREIGN KEY(GroupID) REFERENCES `Group`(GroupID), 
    FOREIGN KEY(AccountID) REFERENCES `Account`(AccountID),
    PRIMARY KEY (GroupID,AccountID)
);
DROP TABLE IF EXISTS Typequestion;
CREATE TABLE TypeQuestion(
	TypeID TINYINT UNSIGNED  AUTO_INCREMENT PRIMARY KEY, 
    TypeName ENUM('Essay', 'Multiple-choice')  NOT NULL UNIQUE KEY 
);
DROP TABLE IF EXISTS Categoryquestion;
CREATE TABLE CategoryQuestion(
	CategoryID    TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    CategoryName VARCHAR(50) NOT NULL UNIQUE KEY
);
DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
	QuestionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    Content NVARCHAR(100) NOT NULL, 
    CategoryID TINYINT UNSIGNED NOT NULL, 
    TypeID TINYINT UNSIGNED NOT NULL, 
    CreatorID TINYINT UNSIGNED NOT NULL, 
    CreateDate DATETIME DEFAULT NOW(), 
    FOREIGN KEY(CategoryID)  REFERENCES CategoryQuestion(CategoryID), 
    FOREIGN KEY(TypeID)   REFERENCES TypeQuestion(TypeID), 
    FOREIGN KEY(CreatorID)   REFERENCES `Account`(AccountId)  
); 
    
 DROP TABLE IF EXISTS Answer;    

CREATE TABLE Answer(
   AnswerID  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
   Content NVARCHAR(100) NOT NULL, 
   QuestionID TINYINT UNSIGNED NOT NULL,
   isCorrect BIT DEFAULT 1, 
   FOREIGN KEY (QuestionID) REFERENCES Question(Questionid)
);
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
    FOREIGN KEY(CreatorID)  REFERENCES `Account`(AccountId) 
);  
DROP TABLE IF EXISTS ExamQuestion; 
CREATE TABLE ExamQuestion(
		ExamID TINYINT UNSIGNED NOT NULL,
		QuestionID TINYINT UNSIGNED NOT NULL,
		FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID), 
		FOREIGN KEY(ExamID) REFERENCES Exam(ExamID) , 
		PRIMARY KEY (ExamID,QuestionID) 
    
   );
INSERT INTO  Department(DepartmentID,DepartmentName)
VALUES
		(1,		N'Marketing' ), 
		(2,		N'Sale'  ), 
		(3,		N'Manager'),
		(4,		N'Security'),
		(5,		N'HR'),
        (6,     N'Account'),
        (7,     N'Cleaning'),
        (8,     N'Supervisor'),
        (9,     N'Tester'),
        (10,    N'Survey');
INSERT INTO Position (PositionID,PositionName ) 
	VALUES(1,'Dev'   ), 
		  (2,'Test'   ), 
		  (3,'Scrum Master' ), 
		  (4,'PM'   ) ,
          (5,'Communicator'),
          (6,'BrSE'),
          (7,'SAP'),
          (8,'CS'),
          (9,'Recruiting'),
          (10,'Fresher');
INSERT INTO	`Account`(Email        ,				 Username   , 				FullName    , DepartmentID , 		PositionID, CreateDate) 
VALUES    	(	 1,		'bc172257@ipu-japan.ac.jp',	'ManhNguyen', 		'Nguyen The Manh',    	1,					1,	 	'2021-08-22'),
            (	 2,		'bc172257@ipu-japan.ac.vn','ManhTran',			'Tran	The Manh',    	2,					2,	 	'2021-08-22'),
			(	 3,		'bc172257@ipu-japan.ac.uk','ManhVu ', 			'Vu The Manh',    		3,					3,	 	'2021-08-22'),
			(	 4,		'bc172257@ipu-japan.ac.us','ManhTa',			'Ta	The	Manh',    		4,					4,	 	'2021-08-22'),
			(	 5,		'bc172257@ipu-japan.ac.ko','ManhBui',			'Bui	The Manh',    	5,					5,	 	'2021-08-22'), 
            (    6,      'bc172257@ipu-japan.ac.ko','ManhNgo',          'Ngo The Manh',         6,             		6 ,     '2021-08-22'),
			(    7,      'bc172257@ipu-japan.ac.ko','ManhNgo',          'Ngo The Manh',         6,             		6 ,     '2021-08-22'),
			(    8,      'bc172257@ipu-japan.ac.ko','ManhNgo',          'Ngo The Manh',         6,             		6 ,     '2021-08-22'),
			(    9,      'bc172257@ipu-japan.ac.ko','ManhNgo',          'Ngo The Manh',         6,             		6 ,     '2021-08-22'),
            (    10,     'bc172257@ipu-japan.ac.ko','ManhNgo',          'Ngo The Manh',         6,             		6 ,     '2021-08-22');
INSERT INTO `Group` (GroupID,	GroupName , CreatorID , CreateDate)
VALUES (1,	N'Testing System' , 1,'2012-02-07'),
		(2,	N'Development' ,2,'2012-04-09'),
		(3,	N' Sale 01' , 3 ,'2012-05-09'),
		(4,	N' Sale 02' , 4 ,'2012-05-10'),
		(5,	N' Sale 03' , 5 ,'2012-06-28'),
		(6,	N' Creator' , 6 ,'2012-08-06'),
		(7,	N' Marketing 01' , 7 ,'2012-09-07'),
		(8,	N'Management' , 8 ,'2012-09-08'),
		(9,	N'Chat with fan', 9 ,'2012-09-09'),
		(10,N'Vi Ti Ai' , 10 ,'2012-09-15');
INSERT INTO `GroupAccount` ( GroupID , AccountID , JoinDate )
VALUES ( 1 , 1,'2021-03-05'),
		( 2 , 2,'2021-03-07'),
		( 3 , 3,'2021-03-09'),
        ( 4 , 4,'2021-03-10'),
		( 5 , 5,'2021-03-28'),
		( 6, 6,'2021-04-06'),
		( 7 , 7,'2021-04-07'),
		( 8 , 8,'2021-04-08'),
		( 9 , 9,'2021-04-09'),
		( 10 , 10,'2021-04-10');

