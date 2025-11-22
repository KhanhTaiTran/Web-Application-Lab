package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            case "sort":
                sortStudents(request, response);
                break;
            case "filter":
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }

    // List students
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

        int recordsPerPage = 10;

        int offset = (currentPage - 1) * recordsPerPage;

        List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);

        int totalRecords = studentDAO.getTotalStudent();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("students", students);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);

        request.setAttribute("student", existingStudent);
        request.setAttribute("formMode", "update"); // ADD THIS

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);

        if (!validateStudent(student, request)) {
            // Set student as attribute (to preserve entered data)
            request.setAttribute("student", student);
            // Set a flag to indicate insert mode
            request.setAttribute("formMode", "insert");
            // Forward back to form
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return; // STOP here
        }

        if (studentDAO.addStudent(student)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);

        if (!validateStudent(student, request)) {
            // Set student as attribute (to preserve entered data)
            request.setAttribute("student", student);
            try {
                // Forward back to form
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
                dispatcher.forward(request, response);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return; // STOP here
        }

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }

    // Search students
    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;

        List<Student> students;
        int totalRecords;

        // Handle null or empty keyword - show all students
        if (keyword == null || keyword.trim().isEmpty()) {
            students = studentDAO.getStudentsPaginated(offset, recordsPerPage);
            totalRecords = studentDAO.getTotalStudent();
        } else {
            students = studentDAO.searchStudentsPaginated(keyword.trim(), offset, recordsPerPage);
            totalRecords = studentDAO.getTotalSearchResults(keyword.trim());
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Set both students list and keyword as attributes
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    // Validate student data
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        String codePattern = "[A-Z]{2}[0-9]{3,}";
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        // Validate student code
        if (student.getStudentCode() == null || student.getStudentCode().trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else if (!student.getStudentCode().matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }

        // Validate full name
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else if (student.getFullName().trim().length() < 2) {
            request.setAttribute("errorName", "Full name must be at least 2 characters");
            isValid = false;
        }

        // Validate email (only if provided)
        if (student.getEmail() != null && !student.getEmail().trim().isEmpty()) {
            if (!student.getEmail().matches(emailPattern)) {
                request.setAttribute("errorEmail", "Invalid email format");
                isValid = false;
            }
        }

        // Validate major
        if (student.getMajor() == null || student.getMajor().trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }

        return isValid;
    }

    private void sortStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;

        // Get paginated sorted students
        List<Student> students = studentDAO.getStudentsSortedPaginated(sortBy, order, offset, recordsPerPage);
        int totalRecords = studentDAO.getTotalStudent();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Set attributes so JSP can display sort indicators and pagination
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    private void filterStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String major = request.getParameter("major");
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;

        // Get paginated filtered students
        List<Student> students = studentDAO.getStudentsFilteredPaginated(major, offset, recordsPerPage);
        int totalRecords = (major == null || major.equals("All Majors"))
                ? studentDAO.getTotalStudent()
                : studentDAO.getTotalStudentsByMajor(major);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("students", students);
        request.setAttribute("selectedMajor", major);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }

}