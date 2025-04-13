package com.example.librarybook.services;

import com.example.librarybook.model.User;
import com.example.librarybook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    // Lấy danh sách tất cả tài khoản
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Tìm tài khoản theo username (cần có hàm findByUsername trong UserRepository)
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    // Tìm tài khoản theo ID
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    // Thêm hoặc cập nhật tài khoản
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public String editUser(User user) {
        User userFindByEmail = userRepository.findByEmail(user.getEmail());
        if (userFindByEmail != null && !userFindByEmail.getId().equals(user.getId())) {
            return "Email đã tồn tại!";
        }
        User userFindByPhoneNumber = userRepository.findByPhoneNumber(user.getPhoneNumber());
        if (userFindByPhoneNumber != null && !userFindByPhoneNumber.getId().equals(user.getId())) {
            return "Số điện thoại đã tồn tại!";
        }
        userRepository.save(user);
        return "Lưu thành công!";
    }

    // Kiểm tra tài khoản đã tồn tại chưa (dùng username)
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    public List<User> searchUser(String username, String fullName, String phoneNumber, String email, String role, Integer status){
        return userRepository.findUserByRequest(username, fullName, phoneNumber, email, role, status);
    }
}
