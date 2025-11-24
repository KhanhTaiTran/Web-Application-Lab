STUDENT INFORMATION:
Name: Tran Khanh Tai
Student ID: ITITIU21300
Class: Web Application Development_S1_2025-26_G02_lab03

COMPLETED EXERCISES:
[x] Exercise 5: Search
[x] Exercise 6: Validation
[x] Exercise 7: Sorting & Filtering
[x] Exercise 8: Pagination
[x] Bonus 1: Export Excel (5 points)
[x] Bonus 2: Photo Upload (5 points)

MVC COMPONENTS:

- Model: Student.java
- DAO: StudentDAO.java
- Controller: StudentController.java
- Additional Controller: ExportServlet.java
- Views: student-list.jsp, student-form.jsp

FEATURES IMPLEMENTED:

- All CRUD operations (Create, Read, Update, Delete)
- Search functionality with pagination support
- Server-side validation (student code pattern, email format, name length)
- Sorting by columns (ID, Student Code, Full Name, Email, Major) with pagination preservation
- Filter by major with pagination support
- Pagination (10 records per page) with state preservation across search/sort/filter
- Excel export functionality with styled output

KNOWN ISSUES:

- None (all features working as expected)

EXTRA FEATURES:

- Form mode handling (insert vs update) to prevent validation errors
- Pagination preserves search query, sort order, and filter selection
- Excel export includes all student data with professional styling

TECHNOLOGIES USED:

- Jakarta EE / Java Servlets 3.0 (Tomcat 7 compatible)
- JSP with JSTL 1.2
- MySQL 8.0.33
- Apache Maven
- Apache POI 5.2.3 (Excel generation)

TIME SPENT: Approximately 15-20 hours
