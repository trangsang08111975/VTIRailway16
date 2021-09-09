
USE TestingSystem4;

SELECT *
FROM `Account`
WHERE AccountID = ANY (SELECT AccountID FROM `Account` WHERE AccountID=2 or	AccountID=3 or AccountID=4);

DROP VIEW IF EXISTS view_account;
CREATE VIEW view_account AS

		SELECT AccountID,Email,FullName,DepartmentName
        FROM	`account`
        JOIN department USING(DepartmentID);
        
SELECT *
FROM view_account;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale--
CREATE VIEW SaleEmployees AS
         SELECT *
         FROM `Account` a
         JOIN department d USING(departmentID)
         WHERE  d.DepartmentName = 'Sale';
         SELECT * FROM SaleEmployees;

-- CACH2 WITH AS
WITH SaleStaff AS(		SELECT *
						FROM `account`A
						JOIN department d USING(departmentID)
						WHERE  d.DepartmentName = 'Sale')
SELECT *
FROM SaleStaff ;


         
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất--


DROP VIEW IF EXISTS					 Account_nangNo;
CREATE OR REPLACE VIEW 				 Account_nangNo
AS
SELECT 		A.*, COUNT(GA.AccountID) ,GROUP_CONCAT(GroupID)
FROM		`Account`	AS  A 
INNER JOIN 	GroupAccount 	AS	GA		 USING (AccountID )
GROUP BY	A.AccountID
HAVING		COUNT(GA.AccountID) = (
									SELECT 		COUNT(GA.AccountID) 
									FROM	`Account`		AS 		A 
									INNER JOIN 	GroupAccount 	AS		GA		 USING	 (AccountID)
									GROUP BY	A.AccountID
									ORDER BY	COUNT(GA.AccountID) DESC
									LIMIT		1
								  );	
SELECT 	*
FROM  	 Account_nangNo;


-- cach2 with as
WITH MostGroupInvolvedAccount AS ( SELECT COUNT(GA1.AccountID) AS countGA1
										 FROM Groupaccount GA1 
                                         GROUP BY GA1.AccountID)
 SELECT A.AccountID, A.Username, count(GA.AccountID)
        FROM Groupaccount GA 
        JOIN `Account` A ON GA.AccountID = A.AccountID
        GROUP BY GA.AccountID 
        HAVING COUNT(GA.AccountID) = (SELECT MAX(countGA1) AS maxCount FROM MostGroupInvolvedAccount
);

    
    
-- Question 3	Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi

CREATE OR REPLACE VIEW Overcontentdelete AS
SELECT *
FROM question 
WHERE LENGTH(Content) >20;

SELECT * 
FROM Overcontentdelete;

DELETE FROM Overcontentdelete;



-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân vien nhat-

CREATE OR REPLACE VIEW vw_MaxNV	AS
SELECT D.DepartmentName, count(A.DepartmentID) 
FROM account A
INNER JOIN `department` D ON D.DepartmentID = A.DepartmentID
GROUP BY A.DepartmentID
HAVING count(A.DepartmentID) = (SELECT MAX(countDEP_ID) AS maxDEP_ID FROM
														(SELECT count(A1.DepartmentID) AS countDEP_ID 
                                                        FROM account A1
														GROUP BY A1.DepartmentID) AS TB_countDepID);
														
SELECT * FROM vw_MaxNV;


-- cach 2 vs with cte
CREATE OR REPLACE VIEW vw_MaxNV AS
WITH CTE_Count_NV AS(	SELECT count(A1.DepartmentID) AS countDe_ID
						FROM account A1
						GROUP BY A1.DepartmentID)

SELECT D.DepartmentName, count(A.DepartmentID) AS SL
FROM account A
INNER JOIN `department` D ON D.DepartmentID = A.DepartmentID
GROUP BY A.DepartmentID
HAVING count(A.DepartmentID) = (SELECT max(countDe_ID)  FROM CTE_Count_NV);
SELECT * FROM vw_MaxNV;



-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo

CREATE OR REPLACE VIEW USER_Nguyen AS
SELECT Q.Content, A.FullName 
FROM Question Q
JOIN `Account` A ON A.AccountID = Q.CreatorID
WHERE SUBSTRING_INDEX(A.FullName,'',1) = 'Nguyễn';

SELECT * FROM USER_Nguyen


-- cach 2 with cte
WITH USER_Nguyen AS(
SELECT  Q.Content, A.FullName 
 FROM question Q
INNER JOIN `account` A ON A.AccountID = Q.CreatorID
WHERE SUBSTRING_INDEX( A.FullName, ' ', 1 ) = 'Nguyễn'
)
SELECT * FROM USER_Nguyen;
    
   
    
    


