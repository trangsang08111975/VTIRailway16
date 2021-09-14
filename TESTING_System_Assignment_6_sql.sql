USE Testingsystem4;

-- Question 1:
DROP PROCEDURE IF EXISTS GetAccFromDep;
DELIMITER //
CREATE PROCEDURE GetAccFromDep(IN Dep_Name NVARCHAR(50))
BEGIN 
        SELECT A.AccountID, A.FullName, D.DepartmentName 
        From `Account` A
        JOIN Department D ON D.DepartmentID = A.DepartmentID
        WHERE D.DepartmentName = Dep_Name;
END//
DELIMITER ;
Call GetAccFromDep('Sale');

-- Quesntion 2: Tao Store de in so luong Account trong moi group
DROP PROCEDURE IF EXISTS GetAccFromGroup;
DELIMITER //
CREATE PROCEDURE GetAccFromGroup(IN GroupName1	NVARCHAR(50))
BEGIN 
        SELECT G.Groupname, COUNT(GA.AccountID) 
        FROM GroupAccount GA
        JOIN `Group` g   ON g.GroupID = GA.GroupID
        WHERE G.GroupName = GroupName1;
END//
DELIMITER ;
Call GetAccFromGroup('Testing System');

-- lay ra tat ca Account khong can goi --
		DROP PROCEDURE IF EXISTS accnum_in_group;
DELIMITER $$
CREATE PROCEDURE accnum_in_group()
	BEGIN
		SELECT groupID, groupname, COUNT(ga.AccountID) , Group_Concat(ga.accountID)
        FROM `Group`
        JOIN groupaccount ga USING(groupID)
        GROUP BY GroupID;
	END $$
DELIMITER ;	
CALL accnum_in_group();



-- Question3: Tao Store de thong ke moi type Question co bao nhieu Question duoc tao trong thang hien tai--

DROP PROCEDURE IF EXISTS CountQuestionTypeWithMonth;
DELIMITER //
CREATE PROCEDURE CountQuestionTypeWithMonth()
BEGIN  
      SELECT Tq.TypeName, COUNT(Q.TypeID)
      FROM Question Q
      JOIN TypeQuestion Tq ON Tq.TypeID = q.TypeID
      WHERE Month(Q.CreateDate) = Month(now()) AND Year(Q.CreateDate) = Year(now())
      GROUP BY Q.TypeID;
      END//
DELIMITER ;
 CALL CountQuestionTypeWithMonth;
 
 -- Question 4: Tao Store de tra ra id cua type question co nhieu cau hoi nhat
 DROP PROCEDURE IF EXISTS MaxTypeQuestion;
 DELIMITER //
 CREATE PROCEDURE  MaxTypeQuestion()
 BEGIN 
       WITH CTE AS
					(SELECT COUNT(Q.TYPEID)	AS SL	
                    FROM Question Q
					GROUP BY Q.TypeID)
	SELECT TQ.TypeName, COUNT(Q.TypeID)	AS SL	FROM Question Q
	JOIN  Typequestion TQ ON TQ.TypeID = Q.TypeID
	GROUP BY Q.TypeID	
	HAVING	COUNT(Q.TypeID) = (SELECT MAX(SL) FROM CTE);
	END//
DELIMITER ;
Call MaxTypeQuestion;



-- Dung OUT--
					DROP PROCEDURE IF EXISTS GetCountQuesFromType; 
					DELIMITER $$ 
					CREATE PROCEDURE GetCountQuesFromType(OUT t_ID TINYINT) 
					BEGIN  
					WITH CTE_CountTypeID AS (  SELECT count(q.TypeID) AS SL 
												FROM question q  
												GROUP BY q.TypeID)  

					SELECT q.TypeID INTO t_ID 
					FROM question q  
                    GROUP BY q.TypeID  
					HAVING COUNT(q.TypeID) = (SELECT max(SL) FROM CTE_CountTypeID); 
					END$$ DELIMITER ; 
					 
					SET @ID =0; 
                    Call GetCountQuesFromType(@ID); 
					 
					SELECT @ID; 




-- Question 5:  Sử dụng store ở question 4 để tìm ra tên của type question --

DROP PROCEDURE IF EXISTS GetCountQuesFromType;
DELIMITER $$ 
CREATE PROCEDURE GetCountQuesFromType() 
BEGIN 
				WITH CTE_MaxTypeID AS(   SELECT count(q.TypeID) AS SL 
				FROM question q  
				GROUP BY q.TypeID )  
	 SELECT tq.TypeName, count(q.TypeID) AS SL 
	 FROM question q  
	 JOIN typequestion tq ON tq.TypeID = q.TypeID 
	 GROUP BY q.TypeID  
	 HAVING count(q.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID); 
	 END$$ 
	 DELIMITER ; 
 CALL GetCountQuesFromType(); 
 
 -- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi 
 -- của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
 
 DROP PROCEDURE IF EXISTS GetAccOrGroup;
 DELIMITER //
 CREATE PROCEDURE GetAccOrGroup( IN Strings VARCHAR(100))
 BEGIN
          SELECT G.GroupName 
          FROM `Group` G  WHERE G.GroupName LIKE CONCAT("%",Strings,"%") 
          UNION
          SELECT A.Username 
          FROM `Account` A WHERE A.UserName LIKE CONCAT("%",Strings,"%"); 
END//
DELIMITER ;

CALL GetAccOrGroup('s');



-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email 
-- và trong store sẽ tự động gán: username sẽ giống email nhưng bỏ phần @..mail đi 
-- positionID: sẽ có default là developer departmentID: 
-- sẽ được cho vào 1 phòng chờ Sau đó in ra kết quả tạo thành công 

DROP PROCEDURE IF EXISTS	InsertInformation;
DELIMITER //
CREATE PROCEDURE InsertInformation( IN Emails VARCHAR(50),
									IN FullNames VARCHAR(50))
                                    
		BEGIN 
				DECLARE Usernames VARCHAR(50) DEFAULT SUBSTRING_INDEX(Emails, '@', 1); 
                DECLARE DepartmentIDs  TINYINT UNSIGNED DEFAULT 11; 
                DECLARE PositionIDs TINYINT UNSIGNED DEFAULT 1; 
				DECLARE CreateDates DATETIME DEFAULT now();
		INSERT INTO `account` (`Email`,   `Username`,  `FullName`,   `DepartmentID`,    `PositionID`,    `CreateDate`)  
        VALUES       (Emails,     Usernames,      Fullnames,          DepartmentIDs,          PositionIDs,         CreateDates); 
        
        END//
DELIMITER ;

CALL InsertInformation('ManhDz@viettel.com.vn','Nguyen Manh'); 
SELECT * FROM `Account`;

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất 

DROP PROCEDURE IF EXISTS GetMaxNameQuesFormNameType; 
DELIMITER //
CREATE PROCEDURE GetMaxNameQuesFormNameType( IN var_Choice VARCHAR(50))
	   BEGIN 
			DECLARE m_TypeID TINYINT UNSIGNED; 
			SELECT tq.TypeID INTO m_TypeID 
            FROM typequestion tq
            WHERE tq.TypeName = var_Choice; 
			IF var_Choice = 'Essay' THEN      
									WITH CTE_LengContent AS(  SELECT length(q.Content) AS leng 
															  FROM question q 
														      WHERE TypeID = m_TypeID) 
										SELECT * FROM question q 
										WHERE TypeID = m_TypeID   
                                        AND length(q.Content) = (SELECT MAX(leng) FROM CTE_LengContent) ;  
			
			ELSEIF var_Choice = 'Multiple-Choice' THEN 
												   WITH CTE_LengContent AS(   SELECT length(q.Content) AS leng 
																			  FROM question q 
																			  WHERE TypeID = m_TypeID) 
														SELECT * FROM question q 
														WHERE TypeID = m_TypeID   
                                                        AND length(q.Content) = (SELECT MAX(leng) FROM CTE_LengContent); 
			END IF; 
		END// 
  DELIMITER ;
  SELECT Content, MAX(LENGTH(Content)) 
  FROM question 
  WHERE TypeID = 1 ;
  
  -- Question 9:Viết 1 store cho phép người dùng xóa exam dựa vào ID Bảng Exam 
  -- có liên kết khóa ngoại đến bảng examquestion vì vậy trước khi xóa dữ liệu trong bảng exam 
  -- cần xóa dữ liệu trong bảng examquestion trước 
		DROP PROCEDURE IF EXISTS DeleteExamWithID; 
        DELIMITER $$ 
        CREATE PROCEDURE DeleteExamWithID (IN in_ExamID TINYINT UNSIGNED) 
					BEGIN 		  DELETE FROM examquestion 
								  WHERE ExamID = in_ExamID;  
								  DELETE FROM Exam 
			                      WHERE ExamID = in_ExamID;  
	    END$$ DELIMITER ; 
 
CALL DeleteExamWithID(7); 

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi 
-- (sử dụng store ở câu 9 để xóa) Sau đó in số lượng record đã remove từ các table liên quan trong khi removing 



-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban 
-- và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc 

DROP PROCEDURE IF EXISTS SP_DelDepFromName; 
DELIMITER $$ 
CREATE PROCEDURE SP_DelDepFromName(IN var_DepartmentName VARCHAR(30)) 
				BEGIN  
					DECLARE v_DepartmentID VARCHAR(30) ;    
					SELECT D1.DepartmentID   INTO v_DepartmentID 
					FROM department D1 
					WHERE D1.DepartmentName = var_DepartmentName;
					UPDATE `account` A 
					SET A.DepartmentID  = '11' 
					WHERE A.DepartmentID = v_DepartmentID;      
					DELETE DepartmentName FROM department d 
					WHERE d.DepartmentName = var_DepartmentName; 
END$$ DELIMITER ; 
 
Call SP_DelDepFromName('Marketing'); 

-- Question 12:Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay.

DROP PROCEDURE IF EXISTS sp_CountQuesInMonth; 
DELIMITER $$ 
CREATE PROCEDURE sp_CountQuesInMonth() 
BEGIN  
				WITH CTE_12Months AS (    SELECT 	   1 AS MONTH              
										  UNION SELECT 2 AS MONTH             
                                          UNION SELECT 3 AS MONTH             
                                          UNION SELECT 4 AS MONTH              
                                          UNION SELECT 5 AS MONTH             
                                          UNION SELECT 6 AS MONTH             
                                          UNION SELECT 7 AS MONTH             
                                          UNION SELECT 8 AS MONTH             
                                          UNION SELECT 9 AS MONTH             
                                          UNION SELECT 10 AS MONTH            
                                          UNION SELECT 11 AS MONTH            
                                          UNION SELECT 12 AS MONTH )  
                                          SELECT M.MONTH, count(month(Q.CreateDate)) AS SL  
                                          FROM CTE_12Months M 
                                          JOIN (			  SELECT * FROM question Q1 	
															  WHERE year(Q1.CreateDate) = year(now()))Q  
                                                              ON M.MONTH = month(Q.CreateDate) 
                                                              GROUP BY M.MONTH; 
END$$ 
DELIMITER ; 
 
Call sp_CountQuesInMonth(); 

 

