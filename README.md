# 🎓 College Management System

A database management system designed to manage and organize college/student-related information using **MySQL**.

The system maintains information related to departments, faculty, courses, students, enrollments, examinations, attendance, and examination results.

---

## 📌 Project Overview

The **College Management System** is a DBMS project developed using **MySQL**.

The main objective of this project is to provide a structured relational database for managing academic information efficiently and reducing manual data management.

---

## 🎯 Objectives

- Manage student information
- Manage department and faculty information
- Manage courses offered by the college
- Maintain student course enrollments
- Manage examination details
- Track student attendance
- Store and manage examination results
- Maintain result audit information
- Perform complex SQL queries
- Demonstrate SQL joins, subqueries, views, procedures, and triggers
- Analyze query performance using `EXPLAIN`

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| MySQL | Database Management System |
| MySQL Workbench | Database Development & SQL Execution |
| SQL | Database Queries and Operations |
| Git | Version Control |
| GitHub | Project Repository |

---

## 🗂️ Database Modules

The database consists of the following major tables:

1. **Department**
2. **Faculty**
3. **Course**
4. **Student**
5. **Enrollment**
6. **Examination**
7. **Attendance**
8. **Result**
9. **Result Audit**

---

## 📁 Project Structure

```text
College_Management_system/
│
├── PPT/
│   └── Student-Management-System.pptx
│
├── data.sql/
│   ├── 1_department.csv
│   ├── 2_faculty.csv
│   ├── 3_course.csv
│   ├── 4_student.csv
│   ├── 5_enrollment.csv
│   ├── 6_examination.csv
│   ├── 7_attendance.csv
│   └── 8_result.csv
│
├── queries/
│   └── student_management_system.sql
│
├── schema/
│   ├── 0_database.sql
│   ├── 1_department.sql
│   ├── 2_faculty.sql
│   ├── 3_course.sql
│   ├── 4_student.sql
│   ├── 5_enrollment.sql
│   ├── 6_examination.sql
│   ├── 7_attendance.sql
│   ├── 8_result.sql
│   └── 9_result_audit.sql
│
└── README.md
