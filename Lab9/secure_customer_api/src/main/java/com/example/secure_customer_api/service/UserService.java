package com.example.secure_customer_api.service;

import com.example.secure_customer_api.dto.LoginRequestDTO;
import com.example.secure_customer_api.dto.LoginResponseDTO;
import com.example.secure_customer_api.dto.RegisterRequestDTO;
import com.example.secure_customer_api.dto.UpdateProfileDTO;
import com.example.secure_customer_api.dto.UserResponseDTO;
import com.example.secure_customer_api.dto.ChangePasswordDTO;

public interface UserService {

    LoginResponseDTO login(LoginRequestDTO loginRequest);

    UserResponseDTO register(RegisterRequestDTO registerRequest);

    UserResponseDTO getCurrentUser(String username);

    void changePassword(String username, ChangePasswordDTO changePasswordDTO);

    // forgot pass
    String generateResetToken(String email);

    // reset pass
    void resetPassword(String resetToken, String newPassword);

    UserResponseDTO getUserProfile(String username);

    UserResponseDTO updateUserProfile(String username, UpdateProfileDTO updateProfileDTO);

    void deleteAccount(String username, String rawPassword);
}
