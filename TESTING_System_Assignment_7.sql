USE testingsystem4;

-- 	Question1:Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo 1 năm trước
DROP TRIGGER IF EXISTS CheckInsertGroup; 
DELIMITER $$ 
CREATE TRIGGER CheckInsertGroup
		BEFORE INSERT ON `Group` 
        FOR EACH ROW
			BEGIN
                       DECLARE v_CreateDate DATETIME;
						SET v_CreateDate = DATE_SUB(NOW(), interval 1 year);
						IF (NEW.CreateDate <= v_CreateDate) THEN
								SIGNAL SQLSTATE '12345' 	
                                SET MESSAGE_TEXT = 'Cant create this group';
						END IF; 
    END$$ DELIMITER ; 
    INSERT INTO `group` (`GroupName`, `CreatorID`, `CreateDate`) 
    VALUES         ('2', '1', '2018-0410 00:00:00');
    
-- Question 2:Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào department "Sale" nữa, 
-- khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"

DROP TRIGGER IF EXISTS No_more_Sale;
DELIMITER $$ 
		CREATE TRIGGER No_more_Sale
	BEFORE INSERT ON `account` 
    FOR EACH ROW
    BEGIN
				DECLARE Dep_ID TINYINT;
                SELECT d.DepartmentID INTO Dep_ID
                FROM department d 
				WHERE d.DepartmentName = 'Sale';
			IF (NEW.DepartmentID =  Dep_ID) THEN 
                SIGNAL SQLSTATE '12345' 
                SET MESSAGE_TEXT = 'Cant add more User to Sale Department'; 
			END IF; 
	 END$$ 
DELIMITER ;


-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user :
DROP TRIGGER IF EXISTS At_Least_5_users; 
DELIMITER $$ 
			CREATE TRIGGER At_Least_5_users
	BEFORE INSERT ON `groupaccount`
    FOR EACH ROW
	BEGIN 
			DECLARE var_CountGroupID TINYINT; 
            SELECT count(GA.GroupID) INTO var_CountGroupID 
            FROM groupaccount GA
            WHERE GA.GroupID = NEW.GroupID; 
            IF (var_CountGroupID >5) THEN 
					SIGNAL SQLSTATE '12345' 
                    SET MESSAGE_TEXT = 'Cant add more User to This Group'; 
			END IF;
	  END$$ 
      DELIMITER ; 
-- Question 4:  Cấu hình 1 bài thi có nhiều nhất là 10 Question 
DROP TRIGGER IF EXISTS LimitQuesNumInExam10; 
DELIMITER $$ 
		CREATE TRIGGER LimitQuesNumInExam10 
	BEFORE INSERT ON `examquestion` 
    FOR EACH ROW 
     BEGIN 
				DECLARE var_CountQuesInExam TINYINT; 
                SELECT count(EQ.ExamID) INTO var_CountQuesInExam
                FROM examquestion EQ 
                WHERE  EQ.ExamID = NEW.ExamID; 
                IF (var_CountQuesInExam >10) THEN 
						SIGNAL SQLSTATE '12345' 
						SET MESSAGE_TEXT = 'Num Question in this Exam is limited 10'; 
				END IF; 
	 END$$ 
DELIMITER ; 


-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), 
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó DROP 
		
DROP TRIGGER IF EXISTS AdminAccountTrigger; 
DELIMITER $$ 
	CREATE TRIGGER AdminAccountTrigger
    BEFORE DELETE ON `Account` 
    FOR EACH ROW 
    BEGIN
			DECLARE v_Email VARCHAR(50); 
		 SET v_Email = 'admin@gmail.com'; 
         IF (OLD.Email = v_Email) THEN 
								SIGNAL SQLSTATE '12345' 
                                SET MESSAGE_TEXT = 'This User Admin, U cant delete it!!'; 
		 END IF; 
         END $$ 
         DELIMITER ;  
         
         DELETE FROM account A WHERE A.Email = 'admin@gmail.com'; 
  
  
-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account,
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID 
-- thì sẽ được phân vào phòng ban "waiting Department"


DROP TRIGGER IF EXISTS SetDepWaittingRoom; 
DELIMITER $$ 
		CREATE TRIGGER SetDepWaittingRoom
        BEFORE INSERT ON `account` 
        FOR EACH ROW
        BEGIN
				DECLARE WaittingRoom VARCHAR(50);
				SELECT D.DepartmentID INTO WaittingRoom
				FROM department D 
                WHERE D.DepartmentName = 'Waitting Room';
                IF (NEW.DepartmentID IS NULL ) THEN 
						SET NEW.DepartmentID = WaittingRoom; 
				END IF; 
		END $$ 
        DELIMITER ;


-- Question 7:  Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng.

DROP TRIGGER IF EXISTS SetMaxAnswer
DELIMITER $$ 
CREATE TRIGGER SetMaxAnswer
BEFORE  INSERT ON Answer
FOR EACH ROW 
	BEGIN 	
				DECLARE CountAnsInQues TINYINT;
				DECLARE CountAnsIsCorrects TINYINT; 
                 SELECT count(A.QuestionID)  INTO CountAnsInQUes 
                 FROM  Answer A 
                 WHERE A.QuestionID = NEW.QuestionID; 
                 
                 SELECT count(1) INTO CountAnsIsCorrects
                 FROM  Answer A 
                 WHERE A.QuestionID = NEW.QuestionID AND A.isCorrect = NEW.isCorrect;
                 
                 IF (CountAnsInQUes > 4 )  OR (v_CountAnsIsCorrects >2) THEN
									SIGNAL SQLSTATE '12345'
                                    SET MESSAGE_TEXT = 'Cant insert more data pls check again!!'; 
				END IF;
	END $$ 
    DELIMITER ;
    
-- Question 8:  Viết trigger sửa lại dữ liệu cho đúng: Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định 
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database 

DROP TRIGGER IF EXISTS GenderFromInput; 
DELIMITER $$
CREATE TRIGGER GenderFromInput 
BEFORE INSERT ON `Account` 
FOR EACH ROW 
		BEGIN	
			 IF NEW.Gender = 'Nam' THEN 
             SET NEW.Gender = 'M'; 
					ELSEIF NEW.Gender = 'Nữ' THEN 
			 SET NEW.Gender = 'F'; 
					 ELSEIF NEW.Gender = 'Chưa xác định' THEN 
			 SET NEW.Gender = 'U'; 
			  END IF ; 
		END $$ DELIMITER ; 
        

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày 
DROP TRIGGER IF EXISTS CheckDateDelExam;
DELIMITER $$ 
CREATE TRIGGER 		CheckDateDelExam
BEFORE DELETE ON `exam` 
FOR EACH ROW 
BEGIN
		 DECLARE  v_CreateDate DATETIME; 
		 SET v_CreateDate =  DATE_SUB(NOW(),INTERVAL 2 DAY);
         IF (OLD.CreateDate > v_CreateDate) THEN
						SIGNAL SQLSTATE '12345' 
			 SET MESSAGE_TEXT = 'Cant Delete This Exam!!';
				END IF ; 
END $$ 
DELIMITER ; 

DELETE FROM exam E WHERE E.ExamID =1; 


-- Question 12: Lấy ra thông tin exam trong đó: Duration <= 30 thì sẽ đổi thành giá trị "Short time" 30 < Duration <= 60 
-- 	thì sẽ đổi thành giá trị "Medium time" Duration > 60 thì sẽ đổi thành giá trị "Long time" 
		
SELECT * FROM exam;
							SELECT e.ExamID, e.Code, e.Title , 
							CASE      
                            WHEN Duration <= 30 THEN 'Short time'                 
                            WHEN Duration <= 60 THEN 'Medium time'     
                            ELSE 'Longtime'     
                            END AS Duration, e.CreateDate, e.Duration 
					FROM exam e; 
	

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là the_number_user_amount
-- 	và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few 
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal 
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher 

SELECT GA.GroupID, COUNT(GA.GroupID),
			CASE
					WHEN COUNT(GA.GroupID) <= 5 THEN 'few' 
                    WHEN COUNT(GA.GroupID) <= 20  THEN 'normal' 
                    ELSE 'higher' 
                    
				END AS SLaccount
                FROM groupaccount GA 
                GROUP BY GA.GroupID; 
                
                
                
-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user,
--  nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User" 

SELECT D.DepartmentName,
			CASE WHEN COUNT(A.DepartmentID) = 0 THEN 'Không có User' 
				ELSE COUNT(A.DepartmentID) 
                END AS SL
			FROM Department D 
            JOIN Account A  ON D.DepartmentID = A.DepartmentID 
            GROUP BY D.DepartmentID; 


  
 
		


    
