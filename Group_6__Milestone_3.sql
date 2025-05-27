CREATE DATABASE soms;
CREATE TABLE member (
    student_id INT (9) NOT NULL,
    gender VARCHAR (6) NOT NULL,
    enrollment_status VARCHAR (15) NOT NULL,
    email_address VARCHAR (50) UNIQUE,
    member_name VARCHAR (50) NOT NULL,
    batch_year_of_enrollment INT (4) NOT NULL,
    degree_program VARCHAR (50) NOT NULL,
    member_total_unpaid_fees DECIMAL (10, 4),
    graduation_date DATE,
    PRIMARY KEY (student_id)
);
CREATE TABLE organization (
    organization_id INT (9) NOT NULL,
    no_of_members INT (3),
    organization_name VARCHAR (50) NOT NULL,
    organization_type VARCHAR (50),
    total_paid_fees DECIMAL (10, 4),
    total_unpaid_fees DECIMAL (10, 4),
    PRIMARY KEY (organization_id)
);
CREATE TABLE fee (
    fee_id INT (9) NOT NULL,
    amount DECIMAL (10, 4),
    payment_status VARCHAR (15) NOT NULL,
    due_date DATE NOT NULL,
    pay_date DATE,
    school_year INT (4),
    semester VARCHAR (10),
    organization_id INT (9),
    student_id INT (9),
    CONSTRAINT fee_organization_id_fk FOREIGN KEY (organization_id) REFERENCES organization(organization_id),
    CONSTRAINT fee_student_id_fk FOREIGN KEY (student_id) REFERENCES member(student_id)
);
CREATE TABLE member_serves (
    school_year INT (4),
    membership_status VARCHAR (15) NOT NULL,
    batch_year_of_membership INT (4),
    semester VARCHAR (10),
    committee_role VARCHAR (50),
    committee VARCHAR (50),
    organization_id INT (9),
    student_id INT (9),
    PRIMARY KEY (organization_id, student_id)
);
-- Queries –
--based on reports to be generated on project specs    

-- Query 1 —-
--GIVEN ORG ID 1    


SELECT
    s.committee_role,
    s.membership_status,
    m.gender,
    m.degree_program,
    s.batch_year_of_membership,
    s.committee
FROM member_serves s
INNER JOIN member m
ON m.student_id = s.student_id
WHERE s.organization_id = 1;


-- Query 2 --
--GIVEN ORG ID 1, SY 2023-2024, SEMESTER 1    
SELECT
    m.member_name,
    f.amount,
    f.payment_status,
    s.batch_year_of_membership,
    s.semester,
    s.school_year
FROM member m
INNER JOIN member_serves s ON m.student_id = s.student_id
INNER JOIN fee f ON m.student_id = f.student_id
WHERE f.payment_status = 'Not Paid'
AND s.organization_id = 1
AND f.school_year = '2023-2024'
AND f.semester = 1;


-- Query 3 --
--GIVEN m.student_id = 2023-2023


SELECT
    o.organization_name,  
    f.amount,
    f.due_date,
    f.payment_status,
    f.school_year,
    f.semester
FROM fee f
INNER JOIN member_serves s ON f.student_id = s.student_id
INNER JOIN organization o ON s.organization_id = o.organization_id
WHERE f.payment_status = 'Not Paid'
AND f.student_id = '2023-2023';


-- Query 4 --
--GIVEN org id = 1, school_year = 2023-2024


SELECT
    m.member_name,
    s.committee_role,
    s.school_year
FROM member_serves s
INNER JOIN member m ON s.student_id = m.student_id
WHERE s.committee_role != 'Member'
AND s.organization_id = 1
AND s.school_year = '2023-2024';  


-- Query 5 --
--GIVEN org_id = 1


SELECT
    m.member_name,
    s.committee_role,
    s.school_year,
FROM member_serves s
INNER JOIN member m ON s.student_id = m.student_id
WHERE s.committee_role = 'President'  
AND s.organization_id = 1
ORDER BY s.school_year DESC;


-- Query 6 --
SELECT member_name "Member", payment_status "Status", due_date "Due On", pay_date "Paid On" FROM fee f LEFT JOIN member m ON f.student_id = m.student_id WHERE organization_id = 101 AND school_year = "2023" AND semester = 1 AND payment_status = "Paid" AND pay_date > due_date;
-- Query 7 --
SELECT COUNT(CASE WHEN membership_status = "Active" THEN 1 END)/COUNT(*) "%Active", COUNT(CASE WHEN membership_status = "Inactive" THEN 1 END)/COUNT(*) "%Inactive" FROM member_serves ms LEFT JOIN organization org ON ms.organization_id = org.organization_id WHERE ms.organization_id = "101";
-- Query 8 --
SELECT member_name "Member", enrollment_status "Enrollment", graduation_date "Graduation Date" FROM member m LEFT JOIN member_serves ms ON m.student_id = ms.student_id WHERE organization_id = 101 AND enrollment_status = "Graduated" AND graduation_date >= DATE_SUB(CURRENT_DATE(), INTERVAL (20 * 6) MONTH);
-- Query 9 --
SELECT SUM(amount) "Total Amount", payment_status "Payment Status" FROM fee f LEFT JOIN organization o ON f.organization_id = o.organization_id WHERE f.organization_id = 101 AND due_date < DATE("2024-01-01") AND COALESCE(pay_date < DATE("2024-01-01"),1) GROUP BY f.payment_status;
-- Query 10 --
SELECT MAX(Amount) "Total Amount", Member FROM (SELECT SUM(amount) "Amount", member_name "Member" FROM fee f LEFT JOIN member m ON f.student_id = m.student_id WHERE f.organization_id = "101" GROUP BY f.student_id) q;






