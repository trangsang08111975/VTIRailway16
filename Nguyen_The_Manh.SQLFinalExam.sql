DROP DATABASE IF EXISTS Student_Marks_Management;
CREATE DATABASE Student_Marks_Management;
USE Student_Marks_Management;


DROP TABLE IF EXISTS Student;
CREATE TABLE Student(
StudentID 	   			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE KEY,
StudentName			NVARCHAR(100) NOT NULL,
Age             TINYINT,
Gender			ENUM('Male','Female','Unknow')
);


DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject`(
SubjectID 	   			TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY UNIQUE KEY,
SubjectName 			NVARCHAR(100) NOT NULL UNIQUE KEY

);


DROP TABLE IF EXISTS StudentSubject;
CREATE TABLE StudentSubject(
StudentID	   			TINYINT UNSIGNED NOT NULL UNIQUE KEY,
SubjectID 			    TINYINT UNSIGNED  NOT NULL UNIQUE KEY,
Mark                    INT,
`Date`			         DATETIME DEFAULT NOW(),
PRIMARY KEY(StudentID,SubjectID ),
FOREIGN KEY(StudentID)  REFERENCES   Student(StudentID),
FOREIGN KEY(SubjectID)  REFERENCES  `Subject`(SubjectID)
);



-- Question 1: Thêm ít nhất 3 bản ghi vào table 

INSERT INTO Student(	StudentID,		 StudentName,			  Age,		Gender	 )
VALUES			   (	1,    		 'Nguyen The Manh',   	 	  23, 	    'Male'	 ),
				   (    2,    		 'Nguyen Manh Dat',     	  15,       'Male'   ),
                   (    3,    		 'Nguyen Thi Giang',    	  50,       'Female' );
                   
                   
INSERT INTO `Subject`(	SubjectID ,		 SubjectName  	 )
VALUES			  	 (		1,    		  'English' 	 ),
					(    	2,   		  'Physics'      ),
					(   	3,    		  'Literature'   );


                  
INSERT INTO  StudentSubject(	StudentID,		   SubjectID ,			  Mark  ,		`Date`		 )
VALUES			 		   (	1,    				  1,   	  			   90, 	      '2021-10-12'	 ),
						   (    2,    				  2,        		   80,        '2021-10-13'    ),
						   (    3,    				  3,        	        0,        '2021-10-14'    );
                           
 
 
-- Question 2:	Viết lệnh để
-- a) Lấy tất cả các môn học không có bất kì điểm nào

SELECT SubjectName
FROM   `Subject` S
JOIN	StudentSubject SS 
WHERE   S. SubjectID = SS.SubjectID AND SS.Mark = 0;

-- b) Lấy danh sách các môn học có ít nhất 2 điểm 

SELECT  S.SubjectName , SS.Mark AS MarksBiggerthan2
FROM   `Subject`S
JOIN	StudentSubject SS
WHERE   S. SubjectID = SS.SubjectID
HAVING  Mark >= 2;

-- Question 3:Tạo view có tên là "StudentInfo" lấy các thông tin về học sinh bao gồm: 
-- Student ID,Subject ID, Student Name, Student Age, Student Gender, Subject Name, Mark, Date 
-- (Với cột Gender show 'Male' để thay thế cho 0, 'Female' thay thế cho 1 và 'Unknow' thay thế cho null) 

DROP VIEW IF EXISTS StudentInfo;
CREATE VIEW StudentInfo AS

		SELECT 	st.StudentID,	S.SubjectID,	st.StudentName,	S.SubjectName, 	st.Age,	st.Gender,	SS.Mark, SS.`Date`
        FROM	StudentSubject SS
        JOIN 	Student st	ON  SS.StudentID = st.StudentID
        JOIN    `Subject`S  ON  SS.SubjectID = S.SubjectID;
        
SELECT *
FROM StudentInfo;


-- Question 4: Không sử dụng On Update Cascade & On Delete Cascade 
-- a) Tạo trigger cho table Subject có tên là SubjectUpdateID:  Khi thay đổi data của cột ID của table Subject, 
-- thì giá trị tương ứng với cột SubjectID của table StudentSubject cũng thay đổi theo 

DROP TRIGGER IF EXISTS  SubjectUpdateID;
DELIMITER $$
	CREATE TRIGGER  SubjectUpdateID
        AFTER UPDATE ON `Subject`
			FOR EACH ROW
				BEGIN
					UPDATE StudentSubject
					SET SubjectID = NEW.SubjectID
					WHERE`Subject`.SubjectID = NEW.SubjectID;
END $$
DELIMITER ;

    
    
-- b) Tạo trigger cho table StudentSubject có tên là StudentDeleteID: 
-- 	Khi xóa data của cột ID của table Student, thì giá trị tương ứng với cột StudentID của table StudentSubject cũng bị xóa theo 
DROP TRIGGER IF EXISTS StudentDeleteID; 
DELIMITER $$ 
CREATE TRIGGER CheckInsertGroup
		AFTER  DELETE ON Student
        FOR EACH ROW
			BEGIN
                      DELETE FROM StudentSubject
                      WHERE Student.StudentID = StudentSubject.StudentID;
		END$$
DELIMITER ; 


-- Question 5: Viết 1 store procedure (có 2 parameters: student name) sẽ xóa tất cả các thông tin liên quan tới học sinh có cùng tên như parameter 
-- Trong trường hợp nhập vào student name = "*" thì procedure sẽ xóa tất cả các học sinh 

DROP PROCEDURE IF EXISTS DeleteStudentInfor()
DELIMITER //
CREATE PROCEDURE DeleteStudentInfor(IN NewStudent_Name	NVARCHAR(100), IN NewStudent_ID TINYINT)
	BEGIN 
		SET foreign_key_checks = 0;
        DELETE
			FROM Student st 
			WHERE st.StudentName = NewStudent_Name;
		DELETE
			FROM StudentSubject ss
			WHERE ss.StudentID = NewStudent_ID;
        
END//
DELIMITER ;

 
 
 





