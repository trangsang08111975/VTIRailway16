DROP DATABASE IF EXISTS TestingSystem1;
CREATE DATABASE TestingSystem1;
USE TestingSystem1;
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
		  AccountID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
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
    CategoryName  VARCHAR(50)
);

-- Table8---
DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
	QuestionID 	SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    Content 	TEXT NOT NULL, 
    CategoryID  TINYINT UNSIGNED NOT NULL, 
    TypeID 		TINYINT UNSIGNED NOT NULL, 
    CreatorID   TINYINT UNSIGNED NOT NULL, 
    CreateDate  DATETIME DEFAULT NOW(), 
    FOREIGN KEY(CategoryID)  REFERENCES CategoryQuestion(CategoryID), 
    FOREIGN KEY(TypeID)      REFERENCES  TypeQuestion(TypeID), 
    FOREIGN KEY(CreatorID)   REFERENCES Account(AccountId)  
); 

-- Table9---
DROP TABLE IF EXISTS Answer;    
CREATE TABLE Answer(
   AnswerID   TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
   Content 	  NVARCHAR(100) NOT NULL, 
   QuestionID SMALLINT UNSIGNED NOT NULL,
   isCorrect  BOOLEAN, 
   FOREIGN KEY (QuestionID) REFERENCES Question(QuestionId)
);

-- Table10---
DROP TABLE IF EXISTS Exam; 
CREATE TABLE 		 Exam(
    ExamID 	   TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
   `Code`      CHAR(10) NOT NULL, 
    Title 	   NVARCHAR(50) NOT NULL, 
    CategoryID TINYINT UNSIGNED NOT NULL,
    Duration   TINYINT UNSIGNED NOT NULL,
    CreatorID  TINYINT UNSIGNED NOT NULL,
    CreateDate DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID), 
    FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountId)
); 

-- Table11--
DROP TABLE IF EXISTS ExamQuestion; 
CREATE TABLE 		 ExamQuestion(
		ExamID TINYINT UNSIGNED NOT NULL,
		QuestionID SMALLINT UNSIGNED NOT NULL,
		FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID), 
		FOREIGN KEY(ExamID) REFERENCES Exam(ExamID) , 
		PRIMARY KEY (ExamID,QuestionID)     
   );

INSERT INTO  Department(DepartmentName)
VALUES
		(	 N'Marketing' 	), 
		(	 N'Sale'  		), 
		(	 N'Manager'		),
		(	 N'Security'	),
		(	 N'HR'			),
        (    N'Account'		),
        (    N'Cleaning'	),
        (    N'Supervisor'	),
        (    N'Tester'		),
        (    N'Survey'		);
        
INSERT INTO `Position` (PositionName ) 
	VALUES('Dev'   		  ), 
		  ('Test'   	  ), 
		  ('Scrum Master' ), 
		  (  'PM'   	  ) ;
          
INSERT INTO	Account	(	Email        ,				 Username   , 				FullName    , 		DepartmentID , 		PositionID ) 
VALUES    	(	 	'bc172257@ipu-japan.ac.jp',		'ManhNguyen', 			'Duyen The Manho',    		5,					1      ),
            (	 	'bc172257@ipu-japan.ac.vn',		'ManhTran',				'Tran	The Manh',    		1,					2	   ),
			(	 	'bc172257@ipu-japan.ac.uk',		'ManhVu ', 				'Vu The Manh',    			2,					2	   ),
			(	 	'bc172257@ipu-japan.ac.us',		'ManhTa',				'Ta	The	Manh',    			3,					4	   ),
			(	 	'bc172257@ipu-japan.ac.ko',		'ManhBui',				'Bui	The Manh',    		4,					4      ), 
            (		'bc172257@ipu-japan.ac.sp',		'ManhNgo',          	'Ngo The Manh',				7,             		3      ),
			(		'bc172257@ipu-japan.ac.gm',		'ManhNha',         	 	'Nha	 The Manh',         2,             		2      ),
			(		'bc172257@ipu-japan.ac.mg',		'ManhThe',          	'Quang	The Manh',         	8,             		1      ),
			(		'bc172257@ipu-japan.ac.ir',		'ManhPhu',          	'Phu	The Manh',         	2,             		2      ),
            (		'bc172257@ipu-japan.ac.br',		'ManhYeu',         	 	'Yeu The Manh',         	10,            		1      );
            
INSERT INTO `Group` (GroupName , CreatorID )
VALUES 				(	N'Tester' , 		1),
					(	N'Development',		2),
					(	N' Sale Junior' , 	3 ),
					(	N' Sale Senior' , 	4 ),
					(	N' Sale Manager' , 	2 ),
					(	N' Creator' , 		6 ),
					(	N' Marketing 01' , 	7 ),
					(	N'	Manager' ,		8 ),
					(	N'Chat with fan', 	9 ),
					(	N'BlackPink' , 		10 );
        
INSERT INTO GroupAccount ( GroupID , AccountID  )
VALUES 	( 1 ,	 1),
		( 2 ,	 2),
		( 3 ,	 3),
        ( 4 ,	 4),
		( 5 ,	 5),
		( 6,	 6),
		( 7 , 	 7),
		( 8 ,	 8),
		( 9 , 	 9),
		( 10 ,  10);
        
INSERT INTO TypeQuestion (TypeName	 )
VALUES ('Essay' ),
	   ('Multiple-Choice' );
		
INSERT INTO CategoryQuestion (CategoryName )
VALUES 
			('Swift'),
			('ASP.NET' ),
			('ADO.NET' ),
			('SQL' ),
			('Javascript'),
			('Ruby' ),
			('Python' ),
			('C++' ),
			('C #' ),
			('PHP' ),
			('Java');
            
INSERT INTO Question 	(Content , 			CategoryID,   TypeID , 	CreatorID, 	CreateDate )
VALUES 					('About Swift',			1 ,			1 , 		'2' ,	'2021-08-29'),
						('About PHP' , 			10 ,		2 , 		'2' ,	'2021-08-29'),
						('About C#' , 			9 ,			1 , 		'3' ,	'2021-08-30'),
						('About Javascript' ,   6 ,			1 , 		'4' ,	'2021-08-30'),
						('About Ruby' , 		5 ,			1 , 		'5' ,	'2021-08-30'),
						('About C++' , 		3 ,			2 , 		'6' ,	'2021-08-31'),
						('About ASP.NET' , 		2 ,			1 , 		'7' ,	'2021-08-31'),
						('About C++' , 			8 ,			1 , 		'8' ,	'2021-08-31'),
						('About SQL' ,			4 ,			2 , 		'9' ,	'2021-08-31'),
						('About Python' , 		7 ,			1 , 		'10',	'2021-08-31');
        
INSERT INTO Answer ( Content , QuestionID , isCorrect )
VALUES 	('Answer 1', 	7 , 	TRUE	),
		('Answer 2',	9 , 	TRUE	),
		('Answer 3', 	1 , 	FALSE	),
		('Answer 4', 	6 , 	TRUE	),
		('Answer 5', 	2 , 	FALSE 	),
		('Answer 6', 	3 , 	TRUE 	),
		('Answer 7', 	4 , 	TRUE 	),
		('Answer 8', 	8 , 	FALSE 	),
		('Answer 9', 	5 ,		TRUE 	),
		('Answer 10', 	10 ,	TRUE 	);
        
INSERT INTO Exam (`Code` , Title , CategoryID
, Duration , CreatorID , CreateDate )
VALUES 	('Railway01' , ' Swift	Exam' ,		1 , 	10 , 	4 ,		'2021-08-29'),
		('Railway02' , ' PHP	Exam' ,		9,		20 , 	2 ,		'2021-08-29'),
		('Railway03' , ' C++	Exam' , 	10 ,	30 , 	2 ,		'2021-08-29'),
		('Railway04' , ' Java	Exam' , 	6 , 	40, 	3 ,		'2021-08-29'),
		('Railway05' , ' Ruby	Exam' , 	5 , 	50, 	4 ,		'2021-08-30'),
		('Railway06' , ' C#		Exam' , 	3 ,		60 , 	6 ,		'2021-08-30'),
		('Railway07' , ' SQL	Exam' ,		2 ,		70 , 	7 ,		'2021-08-30'),
		('Railway08' , ' Python	Exam' ,		7 ,		80 , 	8 ,		'2021-08-30'),
		('Railway09' , 'Javascript Exam' ,	4 ,		90 , 	9 ,		'2021-08-30'),
		('Railway10' , ' ASP.NET Exam' ,	8 ,		100 , 	10 ,	'2021-08-30');
        
INSERT INTO ExamQuestion(ExamID , QuestionID )
VALUES 	( 1 , 5 ),
		( 2 , 9 ),
		( 3 , 4 ),
		( 4 , 3 ),
		( 5 , 7 ),
		( 6 , 7 ),
		( 7 , 2 ),
		( 8 , 10),
		( 9 , 9 ),
		(10 , 8 );

SELECT *
FROM Account
WHERE AccountID>=2 OR AccountID<=4;

SELECT *
FROM Account
WHERE AccountID IN(2,4,5);
  
-- Question 2: l???y ra t???t c??? c??c ph??ng ban --
SELECT *
FROM Department;
-- Question 3: l???y ra id c???a ph??ng ban "Sale"--
SELECT DepartmentID
FROM Department
WHERE DepartmentName = 'Sale';
-- Question 4: l???y ra th??ng tin account c?? full name d??i nh???t--
SELECT *
FROM Account
WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM Account)
ORDER BY Fullname DESC;
-- Question 5: L???y ra th??ng tin account c?? full name d??i nh???t v?? thu???c ph??ng ban c?? id= 3--
WITH `maxfull` AS (SELECT * FROM Account WHERE DepartmentID =3)
SELECT * FROM `maxfull`
WHERE LENGTH(Fullname) = (SELECT MAX(LENGTH(Fullname)) FROM `maxfull`)
ORDER BY Fullname ASC;
-- Question 6: L???y ra t??n group ???? t???o tr?????c ng??y 20/12/2019--
SELECT GroupName
FROM `Group`
WHERE CreateDate < '2021-12-20 00:00:00';
-- Question 7: L???y ra ID c???a question c?? >= 4 c??u tr??? l???i--
SELECT QuestionID, count(QuestionID) AS SL 
From Answer
HAVING count(QuestionID) >=4;
-- Question 8: L???y ra c??c m?? ????? thi c?? th???i gian thi >= 60 ph??t v?? ???????c t???o tr?????c ng??y 20/12/2019
SELECT `Code`
FROM Exam
WHERE Duration >= 60 AND CreateDate < '2021-12-20';
-- Question 9: L???y ra 5 group ???????c t???o g???n ????y nh???t --
SELECT *
FROM `Group`
ORDER BY CreateDate DESC
LIMIT 5;
-- Question 10: ?????m s??? nh??n vi??n thu???c department c?? id = 2--
SELECT departmentID, COUNT(AccountID) AS SL
FROM Account
WHERE DepartmentID = 2;
-- Question 11: L???y ra nh??n vi??n c?? t??n b???t ?????u b???ng ch??? "D" v?? k???t th??c b???ng ch??? "o"--
SELECT Fullname
FROM Account
WHERE (SUBSTRING_INDEX(FullName, ' ', -1)) LIKE 'D%o' ;
-- Question 12: X??a t???t c??? c??c exam ???????c t???o tr?????c ng??y 21/12/2021--
DELETE
FROM Exam
WHERE CreateDate < '2021-12-20';
-- Question 13: X??a t???t c??? c??c question c?? n???i dung b???t ?????u b???ng t??? "c??u h???i"--
DELETE
FROM Question
WHERE (SUBSTRING_INDEX(Content,' ',2)) ='c??u h???i';

-- Question 14: Update th??ng tin c???a account c?? id = 5 th??nh t??n "Nguyen The Manh" v?? email th??nh loc.nguyenba@vti.com.vn
UPDATE Account
SET Fullname = 'Nguyen The Manh',
Email = 'loc.nguyenba@vti.com.vn'
WHERE AccountID = 5;

-- Question 15: update account c?? id = 5 s??? thu???c group c?? id = 4--
UPDATE GroupAccount SET AccountID = 5
WHERE GroupID = 4;

SET foreign_key_checks = 0;
DELETE 
FROM Account
Where AccountID = 2;
SELECT	*,COUNT(*),GROUP_CONCAT(AccountID)
FROM Account
GROUP BY DepartmentID
HAVING COUNT(*) >=2;




