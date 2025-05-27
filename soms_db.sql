DROP DATABASE IF EXISTS soms;
CREATE DATABASE soms;
USE soms;

-- Users table for login
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Insert a sample user
INSERT INTO users (username, password) VALUES ('gift', 'useruser');


-- Member table
CREATE TABLE member (
    student_id INT(9) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    enrollment_status VARCHAR(15) NOT NULL,
    email_address VARCHAR(50) UNIQUE,
    member_name VARCHAR(50) NOT NULL,
    batch_year_of_enrollment INT(4) NOT NULL,
    degree_program VARCHAR(50) NOT NULL,
    member_total_unpaid_fees DECIMAL(10, 4),
    graduation_date DATE,
    PRIMARY KEY (student_id)
);

-- Organization table
CREATE TABLE organization (
    organization_id INT(9) NOT NULL,
    no_of_members INT(3),
    organization_name VARCHAR(50) NOT NULL,
    organization_type VARCHAR(50),
    total_paid_fees DECIMAL(10, 4),
    total_unpaid_fees DECIMAL(10, 4),
    PRIMARY KEY (organization_id)
);

-- Fee table
CREATE TABLE fee (
    fee_id INT(9) NOT NULL,
    amount DECIMAL(10, 4),
    payment_status VARCHAR(15) NOT NULL,
    due_date DATE NOT NULL,
    pay_date DATE,
    school_year INT(4),
    semester VARCHAR(10),
    organization_id INT(9),
    student_id INT(9),
    PRIMARY KEY (fee_id),
    FOREIGN KEY (organization_id) REFERENCES organization(organization_id),
    FOREIGN KEY (student_id) REFERENCES member(student_id)
);

-- Member Serves table
CREATE TABLE member_serves (
    school_year INT(4),
    membership_status VARCHAR(15) NOT NULL,
    batch_year_of_membership INT(4),
    semester VARCHAR(10),
    committee_role VARCHAR(50),
    committee VARCHAR(50),
    organization_id INT(9),
    student_id INT(9),
    PRIMARY KEY (organization_id, student_id, school_year),
    FOREIGN KEY (organization_id) REFERENCES organization(organization_id),
    FOREIGN KEY (student_id) REFERENCES member(student_id)
);

-- Insert sample organizations
INSERT INTO organization VALUES
(101, 2, 'UP Oroquieta', 'Varsitarian', 1000.00, 500.00),
(102, 1, 'UP Silakbo', 'Music', 500.00, 100.00);

-- Insert sample members
INSERT INTO member VALUES
(2023001, 'Male', 'Enrolled', 'john@mail.com', 'John Doe', 2023, 'BSCS', 100.00, NULL),
(2023002, 'Female', 'Enrolled', 'jane@mail.com', 'Jane Smith', 2023, 'BSN', 0.00, NULL),
(2023003, 'Male', 'Graduated', 'mike@mail.com', 'Mike Johnson', 2021, 'BSCS', 50.00, '2025-06-01');

-- Insert sample membership relations
INSERT INTO member_serves VALUES
(2024, 'Active', 2023, '1', 'President', '', 101, 2023001),
(2024, 'Inactive', 2023, '1', 'Member', 'Membership', 101, 2023002),
(2024, 'Alumni', 2021, '1', 'Treasurer', 'Finance', 102, 2023003);

-- Insert sample fees
INSERT INTO fee VALUES
(1, 100.00, 'Paid', '2024-03-01', '2024-02-28', 2024, '1', 101, 2023001),
(2, 50.00, 'Not Paid', '2024-04-01', NULL, 2024, '1', 101, 2023002),
(3, 100.00, 'Paid', '2024-03-15', '2024-03-20', 2024, '1', 102, 2023003);
