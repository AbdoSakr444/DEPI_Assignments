CREATE DATABASE CompanyDB;

USE CompanyDB;

-- Create Employees Table
CREATE TABLE Employees (
SSN INT PRIMARY KEY,
FName VARCHAR(50) NOT NULL,
LName VARCHAR(50) NOT NULL,
Gender VARCHAR(1) CHECK(Gender = 'M' or Gender = 'F'),
BOD DATE,
DNum INT NOT NULL,
Manager_SSN INT,

FOREIGN KEY (Manager_SSN) REFERENCES Employees (SSN) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- i modified DNum to be null just so i can insert employees and later below i will modify this after insertion
ALTER TABLE Employees
ALTER COLUMN DNum INT


-- Create Departments Table
CREATE TABLE Departments (
DNum INT PRIMARY KEY,
DNAME VARCHAR(100) NOT NULL,
Manager_SSN INT NOT NULL UNIQUE,
Hiring_Date Date NOT NULL,

FOREIGN KEY (Manager_SSN) REFERENCES Employees (SSN) ON DELETE NO ACTION ON UPDATE NO ACTION

);



-- Alter Employees Table
ALTER TABLE Employees
ADD FOREIGN KEY (DNum) REFERENCES Departments (DNum)



-- Create Dependent Table
CREATE TABLE Dependents (
Name VARCHAR(100),
Gender VARCHAR(10) DEFAULT 'UnSpecified',
BOD DATE,
Employee_SSN INT NOT NULL,

PRIMARY KEY (Employee_SSN, Name),
FOREIGN KEY (Employee_SSN) REFERENCES EmployeeS(SSN)
);




-- Create Projects Table
CREATE TABLE Projects (
PNumber INT PRIMARY KEY IDENTITY (1,1),
PName VARCHAR(100) NOT NULL,
City_Location VARCHAR(100),
DNum INT NOT NULL,

FOREIGN KEY (DNum) REFERENCES Departments (DNum)
);


-- CREATE WORK Table (Employee work on Projects)
CREATE TABLE EMP_Project_Work (
Employee_SSN INT NOT NULL,
Project_Num INT NOT NULL,
Working_Hours INT NOT NULL,

PRIMARY KEY (Employee_SSN,Project_Num),
FOREIGN KEY (Employee_SSN) REFERENCES Employees (SSN),
FOREIGN KEY (Project_Num) REFERENCES Projects (PNumber)
);



-- Create Departments Locations Table
CREATE TABLE Dept_Locations (
Dept_Num INT NOT NULL,
Location VARCHAR(100) NOT NULL,

PRIMARY KEY (Dept_Num,Location),
FOREIGN KEY (Dept_Num) REFERENCES Departments (DNum)
)







-- Insert Employees First (Managers Only, So They Can Be Referenced Later)
INSERT INTO Employees (SSN, FName, LName, Gender, BOD,Manager_SSN)
VALUES 
(1001, 'John', 'Doe', 'M', '1980-01-01',NULL),
(1002, 'Alice', 'Smith', 'F', '1982-02-02', NULL),
(1003, 'Mike', 'Johnson', 'M', '1978-03-03', NULL);

/*
# Above i don't insert Dnum because there is no data in Departments table so i do this and i will update it later
*/

-- Insert Departments (Referencing Above Employees as Managers)
INSERT INTO Departments (DNum, DNAME, Manager_SSN, Hiring_Date)
VALUES
(1, 'IT', 1001, '2010-01-01'),
(2, 'HR', 1002, '2011-01-01'),
(3, 'Finance', 1003, '2012-01-01');


-- Insert More Employees (Non-Managers)
INSERT INTO Employees (SSN, FName, LName, Gender, BOD, DNum, Manager_SSN)
VALUES
(1004, 'Sara', 'Williams', 'F', '1990-05-05', 1, 1001),
(1005, 'Tom', 'Brown', 'M', '1985-06-06', 2, 1002),
(1006, 'Emma', 'Jones', 'F', '1993-07-07', 3, 1003);

-- Insert Dependents
INSERT INTO Dependents (Name, Gender, BOD, Employee_SSN)
VALUES
('Lily', 'F', '2010-01-01', 1001),
('Ben', 'M', '2012-02-02', 1002),
('Sam', 'M', '2015-03-03', 1003),
('Anna', 'F', '2018-04-04', 1004),
('Ella', 'F', '2017-05-05', 1005);

-- Insert Projects
INSERT INTO Projects (PName, City_Location, DNum)
VALUES
('Website Revamp', 'New York', 1),
('Recruitment Drive', 'Chicago', 2),
('Budget Analysis', 'Boston', 3),
('Cloud Migration', 'Seattle', 1),
('Training Program', 'San Francisco', 2);

-- Insert Employee-Project Work Records
INSERT INTO EMP_Project_Work (Employee_SSN, Project_Num, Working_Hours)
VALUES
(1001, 5, 20),
(1004, 5, 30),
(1005, 2, 25),
(1003, 3, 15),
(1006, 4, 35);


-- Insert Department Locations
INSERT INTO Dept_Locations (Dept_Num, Location)
VALUES
(1, 'New York'),
(1, 'Seattle'),
(2, 'Chicago'),
(2, 'San Francisco'),
(3, 'Boston');



-- Update Employee DATA
UPDATE Employees
SET DNum = 1 WHERE SSN = 1001

UPDATE Employees
SET DNum = 2 WHERE SSN = 1002

UPDATE Employees
SET DNum = 3 WHERE SSN = 1003

ALTER TABLE Employees
ALTER COLUMN DNum INT NOT NULL
