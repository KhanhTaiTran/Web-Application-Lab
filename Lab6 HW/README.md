STUDENT INFORMATION:
Name: Tran Khanh Tai
Student ID: ITITIU21300
Class: Web Application Development_S1_2025-26_G02_lab03

COMPLETED EXERCISES:
[x] Exercise 1: Database & User Model
[x] Exercise 2: User Model & DAO
[x] Exercise 3: Login/Logout Controllers
[x] Exercise 4: Views & Dashboard
[x] Exercise 5: Authentication Filter
[x] Exercise 6: Admin Authorization Filter
[x] Exercise 7: Role-Based UI
[x] Exercise 8: Change Password

AUTHENTICATION COMPONENTS:

- Models: User.java, Student.java
- DAOs: userDAO.java, StudentDAO.java
- Controllers: LoginController.java, LogoutController.java, DashboardController.java, ChangePasswordController.java, StudentController.java, ExportServlet.java
- Filters: AuthFilter.java, AdminFilter.java
- Views: login.jsp, dashboard.jsp, changePassword.jsp, student-list.jsp, student-form.jsp
- Utilities: passwordHashGenerator.java

TEST CREDENTIALS:
Admin:

- Username: admin
- Password: admin123

Regular User:

- Username: khanhtai
- Password: trankhanhtai

FEATURES IMPLEMENTED:

✅ User authentication with BCrypt password hashing
✅ Session management with secure session handling
✅ Login/Logout functionality with proper redirects
✅ Dashboard with real-time statistics (total students, male/female count, average GPA)
✅ Authentication filter (AuthFilter) for protected pages
✅ Admin authorization filter (AdminFilter) for role-based access control
✅ Role-based UI elements (admin-only buttons, conditional rendering)
✅ Change Password functionality (accessible without login)
✅ Student CRUD operations (Create, Read, Update, Delete)
✅ Student list with search/filter capabilities
✅ Export functionality for student data

SECURITY MEASURES:

✅ BCrypt password hashing (with salt generation)
✅ Session regeneration after login to prevent session fixation
✅ Session timeout (30 minutes configured in web.xml)
✅ SQL injection prevention using PreparedStatement
✅ Input validation (server-side validation for password length, required fields)
✅ XSS prevention using JSTL escaping (c:out tags)
✅ AuthFilter protects all pages except public URLs (/login, /logout, /changePassword)
✅ AdminFilter restricts CRUD operations to admin users only
✅ Password change requires authentication with current password

KNOWN ISSUES:

- None currently identified

BONUS FEATURES:

TIME SPENT: Approximately 8-10 hours

TESTING NOTES:

1. **Authentication Testing:**

   - Tested login with valid admin credentials (admin/admin123) ✅
   - Tested login with valid user credentials (khanhtai/trankhanhtai) ✅
   - Tested login with invalid credentials - displays error message ✅
   - Tested logout functionality - clears session and redirects to login ✅

2. **Filter Testing:**

   - Verified AuthFilter blocks unauthenticated access to protected pages ✅
   - Verified AuthFilter allows access to public URLs (/login, /logout, /changePassword) ✅
   - Verified AdminFilter allows admins to perform CRUD operations ✅
   - Verified AdminFilter blocks regular users from CRUD operations ✅

3. **Authorization Testing:**

   - Logged in as admin - can see "Add New," "Edit," "Delete" buttons ✅
   - Logged in as regular user - cannot see admin-only buttons ✅
   - Attempted direct URL access to admin functions as regular user - redirected with error ✅

4. **Change Password Testing:**

   - Accessed change password page from login page without authentication ✅
   - Changed password with valid credentials and new password ✅
   - Verified error handling for invalid username/password ✅
   - Verified password length validation (minimum 6 characters) ✅
   - Verified successful password change redirects to login with success message ✅
   - Verified new password works after change ✅

5. **Session Management Testing:**

   - Verified session timeout after 30 minutes of inactivity ✅
   - Verified session is destroyed on logout ✅
   - Verified session regeneration after successful login ✅

6. **Security Testing:**
   - Verified passwords are stored as BCrypt hashes in database ✅
   - Verified SQL injection prevention with PreparedStatements ✅
   - Verified XSS prevention with JSTL escaping ✅
   - Verified form validation works correctly ✅
