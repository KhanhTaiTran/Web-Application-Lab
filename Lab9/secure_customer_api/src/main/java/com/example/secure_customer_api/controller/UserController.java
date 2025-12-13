package com.example.secure_customer_api.controller;

import org.springframework.security.core.Authentication;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.secure_customer_api.dto.UpdateProfileDTO;
import com.example.secure_customer_api.dto.UserResponseDTO;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.secure_customer_api.service.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // helper method to get current username from security context
    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication.getName();
    }

    // task 7.1
    @GetMapping("/profile")
    public ResponseEntity<UserResponseDTO> getProfile() {
        String username = getCurrentUsername();
        return ResponseEntity.ok(userService.getUserProfile(username));
    }

    // task 7.2
    @PutMapping("/profile")
    public ResponseEntity<UserResponseDTO> updateProfile(@Valid @RequestBody UpdateProfileDTO updateProfileDTO) {
        String username = getCurrentUsername();
        return ResponseEntity.ok(userService.updateUserProfile(username, updateProfileDTO));
    }

    // task 7.3
    @DeleteMapping("/account")
    public ResponseEntity<String> deleteAccount(@RequestParam String password) {
        String username = getCurrentUsername();
        userService.deleteAccount(username, password);
        return ResponseEntity.ok("Account deleted successfully (Soft delete).");
    }

}
