package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/export")
public class ExportServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all students from database
        List<Student> students = studentDAO.getAllStudents();

        // Create Excel workbook
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Students");

        // Create header row with styling
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);

        // Define headers
        String[] headers = { "ID", "Student Code", "Full Name", "Email", "Major", "Created At" };
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // Create data rows
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setAlignment(HorizontalAlignment.LEFT);
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        int rowNum = 1;
        for (Student student : students) {
            Row row = sheet.createRow(rowNum++);

            Cell cell0 = row.createCell(0);
            cell0.setCellValue(student.getId());
            cell0.setCellStyle(dataStyle);

            Cell cell1 = row.createCell(1);
            cell1.setCellValue(student.getStudentCode());
            cell1.setCellStyle(dataStyle);

            Cell cell2 = row.createCell(2);
            cell2.setCellValue(student.getFullName());
            cell2.setCellStyle(dataStyle);

            Cell cell3 = row.createCell(3);
            cell3.setCellValue(student.getEmail());
            cell3.setCellStyle(dataStyle);

            Cell cell4 = row.createCell(4);
            cell4.setCellValue(student.getMajor());
            cell4.setCellStyle(dataStyle);

            Cell cell5 = row.createCell(5);
            cell5.setCellValue(student.getCreatedAt() != null
                    ? dateFormat.format(student.getCreatedAt())
                    : "");
            cell5.setCellStyle(dataStyle);
        }

        // Auto-size columns
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Set response headers for download
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=students.xlsx");

        // Write workbook to response output stream
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
            workbook.close();
        } catch (IOException e) {
            e.printStackTrace();
            throw new ServletException("Error generating Excel file", e);
        }
    }
}
