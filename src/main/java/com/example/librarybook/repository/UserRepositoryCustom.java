package com.example.librarybook.repository;

import java.util.List;

import com.example.librarybook.model.User;

public interface UserRepositoryCustom {
    List<User> findUserByRequest(String username, String fullName, String phoneNumber, String email, String role, Integer status);
}
