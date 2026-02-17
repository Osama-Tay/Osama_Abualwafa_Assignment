-- Q1: Schema Creation with Constraints
CREATE TABLE Gender (
    Gender_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(10) NOT NULL,
    CONSTRAINT chk_gender_name CHECK (Name IN ('Male', 'Female', 'Other'))
);

CREATE TABLE University (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL
);

CREATE TABLE MyDepartment (
    Dept_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL
);

CREATE TABLE MyEmployee (
    ID_Number NUMBER PRIMARY KEY,
    LAST_NAME VARCHAR2(50) NOT NULL,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    HIRE_DATE DATE NOT NULL,
    JOB_TITLE VARCHAR2(50), -- Added as per Q3 requirement
    USERID NUMBER,
    SALARY NUMBER(10, 2),
    DEPT_ID NUMBER,
    Gender_ID NUMBER,
    University_ID NUMBER,
    EMP_IMAGE BLOB,
    CONSTRAINT chk_salary CHECK (SALARY > 0), -- Added CHECK constraint
    CONSTRAINT fk_dept FOREIGN KEY (DEPT_ID) REFERENCES MyDepartment(Dept_ID),
    CONSTRAINT fk_gender FOREIGN KEY (Gender_ID) REFERENCES Gender(Gender_ID),
    CONSTRAINT fk_university FOREIGN KEY (University_ID) REFERENCES University(ID)
);

-- Q2: Data Retrieval Query with Unique Aliases
SELECT 
    e.FIRST_NAME || ' ' || e.LAST_NAME AS "Employee Name",
    e.SALARY AS "Salary",
    d.Name AS "Department Name",
    m.FIRST_NAME || ' ' || m.LAST_NAME AS "Manager Name",
    g.Name AS "Gender",
    u.Name AS "University"
FROM MyEmployee e
LEFT JOIN MyDepartment d ON e.DEPT_ID = d.Dept_ID
LEFT JOIN MyEmployee m ON e.USERID = m.ID_Number
LEFT JOIN Gender g ON e.Gender_ID = g.Gender_ID
LEFT JOIN University u ON e.University_ID = u.ID;

-- Q3: Monthly Salary by Job Title
SELECT 
    JOB_TITLE, 
    SUM(SALARY) AS TOTAL_MONTHLY_SALARY
FROM MyEmployee
WHERE JOB_TITLE != 'Sales'
GROUP BY JOB_TITLE
HAVING SUM(SALARY) > 2500;

-- Q4: Coding Errors Identification
-- Statement: SELECT empno, ename, salary x 12 ANNUAL SALARY; FROM emp;
-- Errors:
-- 1. Operator Error: 'x' is used instead of '*' for multiplication.
-- 2. Syntax Error: The semicolon ';' is placed incorrectly before the 'FROM' clause.
-- 3. Alias Formatting: Missing 'AS' or proper comma placement for the alias 'ANNUAL SALARY'.
-- 4. Schema Check: 'ANNUAL SALARY' with a space requires double quotes or should be 'ANNUAL_SALARY'.

-- Q5: Oracle Function F_HR_QUERY (Updated to find SCOTT internally)
CREATE OR REPLACE FUNCTION F_HR_QUERY 
RETURN SYS_REFCURSOR IS
    rc SYS_REFCURSOR;
    v_scott_hire_date DATE;
BEGIN
    -- Get SCOTT's hire date internally
    SELECT HIRE_DATE INTO v_scott_hire_date 
    FROM MyEmployee 
    WHERE FIRST_NAME = 'SCOTT' AND ROWNUM = 1;

    OPEN rc FOR
        SELECT FIRST_NAME || ' ' || LAST_NAME as Name, HIRE_DATE
        FROM MyEmployee
        WHERE HIRE_DATE > v_scott_hire_date;
    RETURN rc;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        OPEN rc FOR SELECT NULL FROM DUAL WHERE 1=0;
        RETURN rc;
END;
/

-- Q6: Oracle Procedure P_COPY_EMPLOYEE (Ensuring table exists)
CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE AS
    v_count NUMBER;
BEGIN
    -- Check if update table exists, if not create it
    SELECT count(*) INTO v_count FROM user_tables WHERE table_name = 'MYEMPLOYEE_UPDATE';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE MyEmployee_update AS SELECT * FROM MyEmployee WHERE 1=0';
    END IF;

    INSERT INTO MyEmployee_update
    SELECT * FROM MyEmployee;
    
    COMMIT;
END;
/
