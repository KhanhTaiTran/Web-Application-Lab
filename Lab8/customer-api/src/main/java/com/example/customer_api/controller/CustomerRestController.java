package com.example.customer_api.controller;

import com.example.customer_api.dto.CustomerRequestDTO;
import com.example.customer_api.dto.CustomerResponseDTO;
import com.example.customer_api.dto.CustomerUpdateDTO;
import com.example.customer_api.entity.CustomerStatus;
import com.example.customer_api.service.CustomerService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*") // Allow CORS for frontend
public class CustomerRestController {

    private final CustomerService customerService;

    @Autowired
    public CustomerRestController(CustomerService customerService) {
        this.customerService = customerService;
    }

    // TODO: please uncomment the method below to test the original, pagination,
    // sorting, and combinated GET all customers endpoints one by one

    // TODO: uncomment to test: GET all customers
    @GetMapping
    public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
        List<CustomerResponseDTO> customers = customerService.getAllCustomers();
        return ResponseEntity.ok(customers);
    }

    // TODO: uncomment to test: Paginated GET all customers
    // @GetMapping
    // public ResponseEntity<Map<String, Object>>
    // getAllCustomers(@RequestParam(defaultValue = "0") int page,
    // @RequestParam(defaultValue = "10") int size) {
    // Page<CustomerResponseDTO> customerPage =
    // customerService.getAllCustomers(page, size);

    // Map<String, Object> response = new HashMap<>();

    // response.put("customers", customerPage.getContent());
    // response.put("currentPage", customerPage.getNumber());
    // response.put("totalItems", customerPage.getTotalElements());
    // response.put("totalPages", customerPage.getTotalPages());

    // return ResponseEntity.ok(response);
    // }

    // TODO: uncomment to test: Sorted GET all customers
    // @GetMapping
    // public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers(
    // @RequestParam(required = false) String sortBy,
    // @RequestParam(defaultValue = "asc") String sortDir) {

    // Sort sort = sortDir.equalsIgnoreCase("asc")
    // ? Sort.by(sortBy).ascending()
    // : Sort.by(sortBy).descending();

    // List<CustomerResponseDTO> customers = customerService.getAllCustomers(sort);
    // return ResponseEntity.ok(customers);
    // }

    // TODO: uncomment to test: Combined GET all customers: supports pagination and
    // optional sorting
    // @GetMapping
    // public ResponseEntity<Map<String, Object>> getAllCustomers(
    // @RequestParam(defaultValue = "0") int page,
    // @RequestParam(defaultValue = "10") int size,
    // @RequestParam(required = false) String sortBy,
    // @RequestParam(defaultValue = "asc") String sortDir) {

    // Map<String, Object> response = new HashMap<>();

    // if (sortBy != null && !sortBy.isBlank()) {
    // Sort sort = sortDir.equalsIgnoreCase("asc")
    // ? Sort.by(sortBy).ascending()
    // : Sort.by(sortBy).descending();

    // // get sorted full list from service, then paginate in controller
    // List<CustomerResponseDTO> allCustomers =
    // customerService.getAllCustomers(sort);

    // int totalItems = allCustomers.size();
    // int totalPages = (int) Math.ceil((double) totalItems / size);
    // int start = page * size;
    // int end = Math.min(start + size, totalItems);
    // List<CustomerResponseDTO> customersPage = (start < totalItems) ?
    // allCustomers.subList(start, end)
    // : List.of();

    // response.put("customers", customersPage);
    // response.put("currentPage", page);
    // response.put("totalItems", totalItems);
    // response.put("totalPages", totalPages);
    // return ResponseEntity.ok(response);
    // } else {
    // // use service pagination when no sorting requested
    // Page<CustomerResponseDTO> customerPage =
    // customerService.getAllCustomers(page, size);
    // response.put("customers", customerPage.getContent());
    // response.put("currentPage", customerPage.getNumber());
    // response.put("totalItems", customerPage.getTotalElements());
    // response.put("totalPages", customerPage.getTotalPages());
    // return ResponseEntity.ok(response);
    // }
    // }

    // GET customer by ID
    @GetMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> getCustomerById(@PathVariable Long id) {
        CustomerResponseDTO customer = customerService.getCustomerById(id);
        return ResponseEntity.ok(customer);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> partialUpdateCustomer(
            @PathVariable Long id,
            @RequestBody CustomerUpdateDTO updateDTO) {

        CustomerResponseDTO updated = customerService.partialUpdateCustomer(id, updateDTO);
        return ResponseEntity.ok(updated);
    }

    // POST create new customer
    @PostMapping
    public ResponseEntity<CustomerResponseDTO> createCustomer(@Valid @RequestBody CustomerRequestDTO requestDTO) {
        CustomerResponseDTO createdCustomer = customerService.createCustomer(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdCustomer);
    }

    // PUT update customer
    @PutMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> updateCustomer(
            @PathVariable Long id,
            @Valid @RequestBody CustomerRequestDTO requestDTO) {
        CustomerResponseDTO updatedCustomer = customerService.updateCustomer(id, requestDTO);
        return ResponseEntity.ok(updatedCustomer);
    }

    // DELETE customer
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteCustomer(@PathVariable Long id) {
        customerService.deleteCustomer(id);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Customer deleted successfully");
        return ResponseEntity.ok(response);
    }

    // GET search customers
    @GetMapping("/search")
    public ResponseEntity<List<CustomerResponseDTO>> searchCustomers(@RequestParam String keyword) {
        List<CustomerResponseDTO> customers = customerService.searchCustomers(keyword);
        return ResponseEntity.ok(customers);
    }

    @GetMapping("/advanced-search")
    public ResponseEntity<List<CustomerResponseDTO>> advancedSearch(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String status) {
        // search using multiple criteria
        List<CustomerResponseDTO> customers = customerService.advancedSearch(name, email, status);
        return ResponseEntity.ok(customers);
    }

    // GET customers by status
    @GetMapping("/status/{status}")
    public ResponseEntity<List<CustomerResponseDTO>> getCustomersByStatus(@PathVariable CustomerStatus status) {
        List<CustomerResponseDTO> customers = customerService.getCustomersByStatus(status);
        return ResponseEntity.ok(customers);
    }
}
