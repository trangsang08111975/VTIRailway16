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




-- Question 5:  S??? d???ng store ??? question 4 ????? t??m ra t??n c???a type question --

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
 
 -- Question 6: Vi???t 1 store cho ph??p ng?????i d??ng nh???p v??o 1 chu???i v?? tr??? v??? group c?? t??n ch???a chu???i 
 -- c???a ng?????i d??ng nh???p v??o ho???c tr??? v??? user c?? username ch???a chu???i c???a ng?????i d??ng nh???p v??o
 
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



-- Question 7: Vi???t 1 store cho ph??p ng?????i d??ng nh???p v??o th??ng tin fullName, email 
-- v?? trong store s??? t??? ?????ng g??n: username s??? gi???ng email nh??ng b??? ph???n @..mail ??i 
-- positionID: s??? c?? default l?? developer departmentID: 
-- s??? ???????c cho v??o 1 ph??ng ch??? Sau ???? in ra k???t qu??? t???o th??nh c??ng 

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

-- Question 8: Vi???t 1 store cho ph??p ng?????i d??ng nh???p v??o Essay ho???c Multiple-Choice 
-- ????? th???ng k?? c??u h???i essay ho???c multiple-choice n??o c?? content d??i nh???t 

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
  
  -- Question 9:Vi???t 1 store cho ph??p ng?????i d??ng x??a exam d???a v??o ID B???ng Exam 
  -- c?? li??n k???t kh??a ngo???i ?????n b???ng examquestion v?? v???y tr?????c khi x??a d??? li???u trong b???ng exam 
  -- c???n x??a d??? li???u trong b???ng examquestion tr?????c 
		DROP PROCEDURE IF EXISTS DeleteExamWithID; 
        DELIMITER $$ 
        CREATE PROCEDURE DeleteExamWithID (IN in_ExamID TINYINT UNSIGNED) 
					BEGIN 		  DELETE FROM examquestion 
								  WHERE ExamID = in_ExamID;  
								  DELETE FROM Exam 
			                      WHERE ExamID = in_ExamID;  
	    END$$ DELIMITER ; 
 
CALL DeleteExamWithID(7); 

-- Question 10: T??m ra c??c exam ???????c t???o t??? 3 n??m tr?????c v?? x??a c??c exam ???? ??i 
-- (s??? d???ng store ??? c??u 9 ????? x??a) Sau ???? in s??? l?????ng record ???? remove t??? c??c table li??n quan trong khi removing 



-- Question 11: Vi???t store cho ph??p ng?????i d??ng x??a ph??ng ban b???ng c??ch ng?????i d??ng nh???p v??o t??n ph??ng ban 
-- v?? c??c account thu???c ph??ng ban ???? s??? ???????c chuy???n v??? ph??ng ban default l?? ph??ng ban ch??? vi???c 

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

-- Question 12:Vi???t store ????? in ra m???i th??ng c?? bao nhi??u c??u h???i ???????c t???o trong n??m nay.

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

 

