DROP DATABASE IF EXISTS TestingSystem4;
CREATE DATABASE TestingSystem4;
USE TestingSystem4;
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
DepartmentID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
DepartmentName NVARCHAR(30) NOT NULL UNIQUE KEY
);
DROP TABLE IF EXISTS Position;
CREATE TABLE `Position` (
PositionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY
KEY,
PositionName ENUM('Dev','Test','Scrum Master','PM') NOT NULL UNIQUE
KEY
);
DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account`(
AccountID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY
KEY,
Email VARCHAR(50) NOT NULL UNIQUE KEY,
Username VARCHAR(50) NOT NULL UNIQUE KEY,
FullName NVARCHAR(50) NOT NULL,
DepartmentID TINYINT UNSIGNED NOT NULL,
PositionID TINYINT UNSIGNED NOT NULL,
CreateDate DATETIME DEFAULT NOW(),
FOREIGN KEY(DepartmentID) REFERENCES Department(DepartmentID),
FOREIGN KEY(PositionID) REFERENCES `Position`(PositionID)
);
DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
GroupID TINYINT UNSIGNED AUTO_INCREMENT
PRIMARY KEY,

GroupName NVARCHAR(50) NOT NULL UNIQUE KEY,
CreatorID TINYINT UNSIGNED,
CreateDate DATETIME DEFAULT NOW(),
FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountId)
);
DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount(
GroupID TINYINT UNSIGNED NOT NULL,
AccountID TINYINT UNSIGNED NOT NULL,
JoinDate DATETIME DEFAULT NOW(),
PRIMARY KEY (GroupID,AccountID),
FOREIGN KEY(GroupID) REFERENCES `Group`(GroupID),
FOREIGN KEY(AccountID) REFERENCES `Account`(AccountID)
);
DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion (
TypeID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
TypeName ENUM('Essay','Multiple-Choice') NOT NULL UNIQUE KEY
);
DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion(
CategoryID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
CategoryName NVARCHAR(50) NOT NULL UNIQUE KEY
);
DROP TABLE IF EXISTS Question;
CREATE TABLE Question(
QuestionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
Content NVARCHAR(100) NOT NULL,
CategoryID TINYINT UNSIGNED NOT NULL,
TypeID TINYINT UNSIGNED NOT NULL,
CreatorID TINYINT UNSIGNED NOT NULL,

CreateDate DATETIME DEFAULT NOW(),
FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID),
FOREIGN KEY(TypeID) REFERENCES TypeQuestion(TypeID),
FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountId)
);
DROP TABLE IF EXISTS Answer;
CREATE TABLE Answer(
AnswerID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
Content NVARCHAR(100) NOT NULL,
QuestionID TINYINT UNSIGNED NOT NULL,
isCorrect BIT DEFAULT 1,
FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID)
);
DROP TABLE IF EXISTS Exam;
CREATE TABLE Exam(
ExamID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY
KEY,
`Code` CHAR(10) NOT NULL,
Title NVARCHAR(50) NOT NULL,
CategoryID TINYINT UNSIGNED NOT NULL,
Duration TINYINT UNSIGNED NOT NULL,
CreatorID TINYINT UNSIGNED NOT NULL,
CreateDate DATETIME DEFAULT NOW(),
FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID),
FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountId)
);
DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
ExamID TINYINT UNSIGNED NOT NULL,
QuestionID TINYINT UNSIGNED NOT NULL,
FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID),

FOREIGN KEY(ExamID) REFERENCES Exam(ExamID) ,
PRIMARY KEY (ExamID,QuestionID)
);
INSERT INTO Department(DepartmentName)
VALUES

(N'Marketing' ),
(N'Sale' ),
(N'B???o v???' ),
(N'Nh??n s???' ),
(N'K??? thu???t' ),
(N'T??i ch??nh' ),
(N'Ph?? gi??m ?????c'),
(N'Gi??m ?????c' ),
(N'Th?? k??' ),
(N'No person' ),
(N'B??n h??ng' );

INSERT INTO Position (PositionName )
VALUES ('Dev' ),
('Test' ),
('Scrum Master'),
('PM' );

INSERT INTO `Account`(Email , Username
, FullName , DepartmentID , PositionID,

CreateDate)
VALUES ('Email1@gmail.com' ,'Username1' ,'Fullname1' , '5' , '1','2020-03-05'),
	   ('Email2@gmail.com' ,'Username2' ,'Fullname2' , '1' , '2','2020-03-05'),
       ('Email3@gmail.com' , 'Username3' ,'Fullname3', '2' , '2' ,'2020-03-07'),
	   ('Email4@gmail.com' , 'Username4' ,'Fullname4', '3' , '4' ,'2020-03-08'),
	   ('Email5@gmail.com' , 'Username5' ,'Fullname5', '4' , '4' ,'2020-03-10'),
	   ('Email6@gmail.com' , 'Username6' ,'Fullname6', '6' , '3' ,'2020-04-05'),
	   ('Email7@gmail.com' , 'Username7' ,'Fullname7', '2' , '2' , NULL ),
	   ('Email8@gmail.com' , 'Username8' ,'Fullname8', '8' , '1' ,'2020-04-07'),
	   ('Email9@gmail.com' , 'Username9' ,'Fullname9', '2' , '2' ,'2020-04-07'),
	   ('Email10@gmail.com' , 'Username10' ,'Fullname10', '10' , '1' ,'2020-04-09'),
       ('Email11@gmail.com' , 'Username11' ,'Fullname11', '10' , '1' , DEFAULT),
       ('Email12@gmail.com' , 'Username12','Fullname12' , '10' , '1' , DEFAULT);
INSERT INTO `Group` ( GroupName , CreatorID , CreateDate)
VALUES (N'Testing System' , 5,'2019-03-05'),
	   (N'VTI Sale 01' , 2 ,'2020-03-09'),
	   (N'VTI Sale 02' , 3 ,'2020-03-10'),
	   (N'VTI Sale 03' , 4 ,'2020-03-28'),
	   (N'VTI Creator' , 6 ,'2020-04-06'),
	   (N'VTI Marketing 01' , 7 ,'2020-04-07'),
	   (N'Management' , 8 ,'2020-04-08'),
	   (N'Chat with love' , 9 ,'2020-04-09'),
	   (N'Vi Ti Ai' , 10 ,'2020-04-10');
INSERT INTO `GroupAccount` ( GroupID , AccountID , JoinDate )
VALUES ( 1 , 1,'2019-03-05'),
	   ( 1 , 2,'2020-03-07'),
	   ( 3 , 3,'2020-03-09'),
	   ( 3 , 4,'2020-03-10'),
	   ( 5 , 5,'2020-03-28'),
       ( 1 , 3,'2020-04-06'),
       ( 1 , 7,'2020-04-07'),
	   ( 8 , 3,'2020-04-08'),
	   ( 1 , 9,'2020-04-09'),
	   ( 10 , 10,'2020-04-10');

INSERT INTO TypeQuestion (TypeName )
VALUES ('Essay' ),
('Multiple-Choice' );

INSERT INTO CategoryQuestion (CategoryName )
VALUES ('Java' ),
('ASP.NET' ),
('ADO.NET' ),
('SQL' ),
('Postman' ),
('Ruby' ),
('Python' ),
('C++' ),
('C Sharp' ),
('PHP' );

INSERT INTO Question (Content , CategoryID, TypeID , CreatorID
, CreateDate )
VALUES (N'C??u h???i v??? Java' , 1 ,'1' , '2' ,'2020-04-05'),
	   (N'C??u H???i v??? PHP' , 10 ,'2' , '2' ,'2020-04-05'),
	   (N'H???i v??? C#' , 9 ,'2' , '3' ,'2020-04-06'),
       (N'H???i v??? Ruby' , 6 ,'1' , '4' ,'2020-04-06'),
       (N'H???i v??? Postman' , 5 ,'1' , '5' ,'2020-04-06'),
       (N'H???i v??? ADO.NET' , 3 ,'2' , '6' ,'2020-04-06'),
       (N'H???i v??? ASP.NET' , 2 ,'1' , '7' ,'2020-04-06'),
       (N'H???i v??? C++' , 8 ,'1' , '8' ,'2020-04-07'),
       (N'H???i v??? SQL' , 4 ,'2' , '9' ,'2020-04-07'),
       (N'H???i v??? Python' , 7 ,'1' , '10' ,'2020-04-07');
INSERT INTO Answer ( Content , QuestionID , isCorrect )
VALUES (N'Tr??? l???i 01' , 1 , 0
),

(N'Tr??? l???i 02' , 1 , 1),
(N'Tr??? l???i 03', 1 , 0 ),
(N'Tr??? l???i 04', 1 , 1 ),
(N'Tr??? l???i 05', 2 , 1 ),
(N'Tr??? l???i 06', 3 , 1 ),
(N'Tr??? l???i 07', 4 , 0 ),
(N'Tr??? l???i 08', 8 , 0 ),
(N'Tr??? l???i 09', 9 , 1 ),
(N'Tr??? l???i 10', 10 , 1 );

INSERT INTO Exam (`Code` , Title , CategoryID
, Duration , CreatorID , CreateDate )
VALUES ('VTIQ001' , N'????? thi C#' ,1 , 60 , '5' ,'2019-04-05'),
	   ('VTIQ002' , N'????? thi PHP' ,10 , 60 , '2' ,'2019-04-05'),
       ('VTIQ003' , N'????? thi C++' , 9 ,120 , '2' ,'2019-04-07'),
       ('VTIQ004' , N'????? thi Java' , 6 , 60, '3' ,'2020-04-08'),
       ('VTIQ005' , N'????? thi Ruby' , 5 , 120, '4' ,'2020-04-10'),
       ('VTIQ006' , N'????? thi Postman' , 3 ,60 , '6' ,'2020-04-05'),
	   ('VTIQ007' , N'????? thi SQL' , 2 ,60 , '7' ,'2020-04-05'),
	   ('VTIQ008' , N'????? thi Python' , 8 ,60 , '8' ,'2020-04-07'),
	   ('VTIQ009' , N'????? thi ADO.NET' , 4 ,90 , '9' ,'2020-04-07'),
	   ('VTIQ010' , N'????? thi ASP.NET' , 7 ,90 , '10' ,'2020-04-08');

INSERT INTO ExamQuestion(ExamID , QuestionID )
VALUES ( 1 , 5 ),
	   ( 2 , 10 ),
	   ( 3 , 4 ),
	   ( 4 , 3 ),
	   ( 5 , 7 ),
	   ( 6 , 10 ),
	   ( 7 , 2 ),
	   ( 8 , 10 ),
	   ( 9 , 9 ),
	   ( 10 , 8 );
-- Question 1: Vi???t l???nh ????? l???y ra danh s??ch nh??n vi??n v?? th??ng tin ph??ng ban c???a h???--
SELECT A.Email, A.Username , A.FullName, D.DepartmentName
FROM `Account` A
INNER JOIN Department D ON A.DepartmentID = D.DepartmentID;

-- Question 2: Vi???t l???nh ????? l???y ra th??ng tin c??c account ???????c t???o sau ng??y 20/12/2010--
SELECT *
FROM `Account`
WHERE CreateDate < '2020-12-20';
-- Question 3: Vi???t l???nh ????? l???y ra t???t c??? c??c developer--
SELECT * FROM `Account`
JOIN `Position` USING(PositionID)
WHERE PositionName = 'Dev';

-- Question 4: Vi???t l???nh ????? l???y ra danh s??ch c??c ph??ng ban c?? >3 nh??n vi??n--

SELECT * , COUNT(a.DepartmentID)
FROM department d
JOIN account a ON d.DepartmentID = a.DepartmentID
-- WHERE kh??ng d??ng ???????c khi ?????m h??m count
GROUP BY a.DepartmentID
HAVING COUNT(a.DepartmentID) >3;

-- Question 5: Vi???t l???nh ????? l???y ra danh s??ch c??u h???i ???????c s??? d???ng trong ????? thi nhi???u 
-- nh???t
-- x??c ?????nh table examquestion ???????c s??? d???ng v?? c?? examID,questionID
-- xem d??? li???u c?? questionID 10 xu???t hi???n nhi???u nh???t trong c??c ????? thi l?? 3 l???n
-- t??m c??u h???i xu???t hi???n trong ????? thi nhi???u nh???t l?? bao nhi???u l???n (d??ng c??u l???nh truy v???n con ????? t??m) = 3 l???n
-- l???y ra danh s??ch c??u h???i ???????c s??? d???ng trong ????? thi 3 l???n

-- Question5-- Vi???t l???nh ????? l???y ra danh s??ch c??u h???i ???????c s??? d???ng trong ????? thi nhi???u nh???t--
SELECT 			QuestionID
FROM            Examquestion
GROUP BY        QuestionID
HAVING COUNT(QuestionID) =(SELECT COUNT(QuestionID) FROM Examquestion
						   GROUP BY QuestionID
						   ORDER BY COUNT(QuestionID) DESC
						   LIMIT 1);
		-- Lay ca content --
					SELECT 			Content
					FROM            question q
                    JOIN examquestion eq ON q.QuestionID = eq.QuestionID
					GROUP BY        eq.QuestionID
					HAVING COUNT(eq.QuestionID) =(SELECT COUNT(QuestionID) 
											   FROM Examquestion
											   GROUP BY QuestionID
											   ORDER BY COUNT(QuestionID) DESC
											   LIMIT 1);
       -- Cach 2--
          SELECT MAX(MyCount)
				FROM
				(SELECT 
				COUNT(QuestionID) MyCount
				FROM examquestion
				GROUP BY QuestionID) AS maxcount;


-- Question 6: Th??ng k?? m???i Category Question ???????c s??? d???ng trong bao nhi??u Question ?--
SELECT *,COUNT(CategoryID), CategoryName
FROM Question
JOIN Categoryquestion USING(CategoryID)
GROUP BY CategoryID;



-- Question 7: Th??ng k?? m???i Question ???????c s??? d???ng trong bao nhi??u Exam--
SELECT q.QuestionID, q.Content , count(eq.QuestionID) 
FROM examquestion eq
JOIN question q ON q.QuestionID = eq.QuestionID
GROUP BY q.QuestionID;

-- cach 2
SELECT*, COUNT(questionID)
FROM Examquestion
JOIN Exam USING(ExamID)
GROUP BY (QuestionID);

-- Question 8: L???y ra Question c?? nhi???u c??u tr??? l???i nh???t--
SELECT	q.QuestionID ,	q.Content, Count(a.QuestionID) 
FROM Answer a
JOIN question q ON  Q.QuestionID = A.QuestionID
GROUP BY a.QuestionID
HAVING COUNT(a.QuestionID) = (SELECT COUNT(a.QuestionID) FROM Answer a
                              GROUP BY a.QuestionID
							  ORDER BY COUNT(a.QuestionID) DESC
							  LIMIT 1);
-- cach 2--							
SELECT Q.QuestionID, Q.Content, count(A.QuestionID) FROM answer A
INNER JOIN question Q ON Q.QuestionID = A.QuestionID
GROUP BY A.QuestionID
HAVING count(A.QuestionID) = (SELECT max(countQues) 
							  FROM (SELECT count(B.QuestionID) AS countQues FROM answer B
							  GROUP BY B.QuestionID) AS countAnsw);


-- Question 9: Th???ng k?? s??? l?????ng account trong m???i group --
		SELECT G.GroupID, COUNT(GA.AccountID) AS 'SO LUONG'
		FROM GroupAccount GA
		JOIN `Group` G ON GA.GroupID = G.GroupID
		GROUP BY G.GroupID
		ORDER BY G.GroupID ASC;
        
        
-- Question 10: T??m ch???c v??? c?? ??t ng?????i nh???t --
SELECT P.PositionID, P.PositionName, count( A.PositionID) AS SL FROM	`Account`A
JOIN position P ON A.PositionID = P.PositionID
GROUP BY A.PositionID
HAVING count(A.PositionID)= (SELECT MIN(minP) 
										FROM(SELECT count(B.PositionID) AS minP 
                                        FROM account B
										GROUP BY B.PositionID) AS minPA);
   
   
-- Question 11: Th???ng k?? m???i ph??ng ban c?? bao nhi??u dev, test, scrum master, PM--
			SELECT d.DepartmentID,d.DepartmentName, p.PositionName, count(p.PositionName) AS SL
            FROM `Account` a
			JOIN department d ON a.DepartmentID = d.DepartmentID
			JOIN position p ON a.PositionID = p.PositionID
			GROUP BY d.DepartmentID, p.PositionID;
            

-- Question 12: L???y th??ng tin chi ti???t c???a c??u h???i bao g???m: th??ng tin c?? b???n c???a question, lo???i c??u h???i, ai l?? ng?????i t???o ra c??u h???i, c??u tr??? l???i l?? g??, ...

			SELECT *
            FROM Question q
            JOIN Categoryquestion cq ON q.CategoryID = cq.CategoryID
            JOIN Answer a ON q.questionID = a.questionID
            JOIN `Account` ac ON ac.AccountID = q.CreatorID
            ORDER BY q.QuestionID ASC;
            
            
-- Question 13: L???y ra s??? l?????ng c??u h???i c???a m???i lo???i t??? lu???n hay tr???c nghi???m
     
            SELECT tq.TypeName, COUNT(q.TypeID)
            FROM	question q
            JOIN typequestion tq ON q.TypeID = tq.TypeID
			GROUP BY q.TypeID;    
            
-- Question 14:L???y ra group kh??ng c?? account n??o S??? d???ng Left Join
   SELECT *
   From `group` g
   LEFT JOIN groupaccount ga ON g.GroupID = ga.GroupID
   WHERE ga.GroupID IS NULL;
-- Question 15: L???y ra group kh??ng c?? account n??o--
SELECT *
FROM `Group`
WHERE GroupID NOT IN (SELECT GroupID
FROM GroupAccount);


-- Question 16: L???y ra question kh??ng c?? answer n??o
SELECT *
FROM question q
WHERE q.questionID NOT IN( SELECT questionID FROM Answer);

-- cach 2--
SELECT q.Content         
FROM answer an 
RIGHT JOIN question q ON q.QuestionID = an.QuestionID
WHERE an.AnswerID IS NULL;

-- Question17 :
-- a) L???y c??c account thu???c nh??m th??? 1 --
SELECT A.FullName FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 1;


-- L???y c??c account thu???c nh??m th??? 2--
SELECT A.FullName FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 2;

-- Gh??p 2 k???t qu??? t??? c??u a) v?? c??u b) sao cho kh??ng c?? record n??o tr??ng nhau --
SELECT A.FullName
FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 1
UNION
SELECT A.FullName
FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 2;


-- Question 18:--
-- a) L???y c??c group c?? l???n h??n 5 th??nh vi??n--
SELECT GroupName g, COUNT( ga.GroupID) AS quantity
FROM Groupaccount ga
JOIN `Group` g ON g.GroupID = ga.GroupID
GROUP BY G.GroupID	
HAVING COUNT( ga.GroupID)>=5;

-- B)L???y c??c group c?? nh??? h??n 7 th??nh vi??n--

SELECT GroupName g, COUNT( ga.GroupID) AS quantity
FROM Groupaccount ga
JOIN `Group` g ON g.GroupID = ga.GroupID
GROUP BY G.GroupID	
HAVING COUNT( ga.GroupID)<=7;


-- c) Gh??p 2 k???t qu??? t??? c??u a) v?? c??u b)

SELECT GroupName g, COUNT( ga.GroupID) AS quantity
FROM Groupaccount ga
JOIN `Group` g ON g.GroupID = ga.GroupID
GROUP BY G.GroupID	
HAVING COUNT( ga.GroupID)>=5
UNION
SELECT GroupName g, COUNT( ga.GroupID) AS quantity
FROM Groupaccount ga
JOIN `Group` g ON g.GroupID = ga.GroupID
GROUP BY G.GroupID	
HAVING COUNT( ga.GroupID)<=7;


		   
