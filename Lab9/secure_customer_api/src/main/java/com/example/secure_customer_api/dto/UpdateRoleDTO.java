package com.example.secure_customer_api.dto;

import jakarta.validation.constraints.NotNull;

import com.example.secure_customer_api.entity.Role;

public class UpdateRoleDTO {
    @NotNull
    private Role role;

    public UpdateRoleDTO() {

    }

    public UpdateRoleDTO(Role role) {
        this.role = role;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
