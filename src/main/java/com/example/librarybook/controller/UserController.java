package com.example.librarybook.controller;

import com.example.librarybook.model.User;
import com.example.librarybook.model.Cart;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.Employee;
import com.example.librarybook.services.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;
    
    @GetMapping()
    public User getUserSession(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user;
    }
    
    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> signin(@RequestBody User user, HttpSession session) {
        String username = user.getUsername();
        String password = user.getPassword();
        Map<String, String> response = new HashMap<>();
        if (userService.existsByUsername(username)) {
            User tmp = userService.getUserByUsername(username).get();
            
            String role = tmp.getRole();
            if (password.equals(tmp.getPassword()) && tmp.getStatus() == 1) {
                session.setAttribute("user", tmp);
                session.setAttribute("role", role);
                response.put("message", "Đăng nhập thành công!");
                response.put("role", role);
                return ResponseEntity.ok(response);
            } else if(!password.equals(tmp.getPassword())) {
                response.put("message", "Mật khẩu không chính xác!");
                return ResponseEntity.badRequest().body(response);
            }
        }
        response.put("message", "Tài khoản không tồn tại!");
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/add")
    public ResponseEntity<Map<String, String>> saveUser(@RequestBody User user) {
        // Kiểm tra tài khoản đã tồn tại chưa
        if (userService.existsByUsername(user.getUsername())) {
            Map<String, String> response = new HashMap<>();
            response.put("message", "Tên người dùng đã tồn tại!");
            return ResponseEntity.badRequest().body(response);
        }

        // Tạo tài khoản mới
        User newUser = new User();
        newUser.setUsername(user.getUsername());
        newUser.setPassword(user.getPassword());
        newUser.setAddress(user.getAddress() == "" ? null : user.getAddress());
        newUser.setFullName(user.getFullName() == "" ? null : user.getFullName());
        newUser.setPhoneNumber(user.getPhoneNumber() == "" ? null : user.getPhoneNumber());
        newUser.setEmail(user.getEmail() == "" ? null : user.getEmail());
        newUser.setStatus(1);
        
        String role = user.getRole();
        if(role.equals("CUSTOMER")){
            Customer customer = new Customer();
            Cart cart = new Cart();
            newUser.setRole("CUSTOMER");
            newUser.setCustomer(customer);
            customer.setUser(newUser);
            customer.setId(newUser.getId());
            cart.setCustomer(customer);
            cart.setId(customer.getId());
            customer.setCart(cart);
        } else if(role.equals("ADMIN")){
            Employee employee = new Employee();
            newUser.setRole("ADMIN");
            newUser.setEmployee(employee);
            employee.setUser(newUser);
            employee.setId(newUser.getId());
        } else {
            Employee employee = new Employee();
            newUser.setRole("EMPLOYEE");
            newUser.setEmployee(employee);
            employee.setUser(newUser);
            employee.setId(newUser.getId());
        }

        userService.saveUser(newUser);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Đăng ký thành công!");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/setprofile")
    public ResponseEntity<Map<String, String>> setProfile(@RequestBody User user, HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        User currentUser = userService.getUserById(sessionUser.getId()).get();
        currentUser.setAddress(user.getAddress());
        currentUser.setEmail(user.getEmail());
        currentUser.setFullName(user.getFullName());
        currentUser.setPhoneNumber(user.getPhoneNumber());
        
        Map<String, String> response = new HashMap<>();
        String result = userService.editUser(currentUser);
        if (!result.equals("Lưu thành công!")) {
            response.put("message", result);
            return ResponseEntity.badRequest().body(response);
        }
        response.put("message", "Sửa thông tin thành công!");
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchUsers(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String role,
            @RequestParam Long page,
            @RequestParam Long pageSize) {
        Long offset = (page-1)*pageSize;
        Long totalAccount = userService.countUserByRequest(username, fullName, phoneNumber, email, role, 1);
        Long totalPages = totalAccount / pageSize;
        if (totalPages* pageSize < totalAccount) 
            totalPages += 1;
        List<User> users = userService.searchUser(username, fullName, phoneNumber, email, role, 1, offset, pageSize);
        Map<String, Object> result = new HashMap<>();
        result.put("users", users);
        result.put("totalPages", totalPages);
        result.put("totalAccount", totalAccount);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/information")
    public ResponseEntity<User> infomation(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        User currentUser = userService.getUserById(sessionUser.getId()).get();
        if(currentUser != null){
            return ResponseEntity.ok(currentUser);
        } else{
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
    
    @PostMapping("/changepassword")
    public ResponseEntity<Map<String, String>> changePassword(@RequestBody User user, HttpSession session){
        User sessionUser = (User) session.getAttribute("user");
        User currentUser = userService.getUserById(sessionUser.getId()).get();
        currentUser.setPassword(user.getPassword());
        userService.saveUser(currentUser);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Dổi mật khẩu thành công!");
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/{userId}")
    public User getUserbyId(@PathVariable Long userId) {
        User user = userService.getUserById(userId).get();
        return user;
    }
    //chua postman
    @PostMapping("/update")
    public ResponseEntity<Map<String,String>> updateCustomer(@RequestBody User user) {
        User tmp = userService.getUserByUsername(user.getUsername()).get();
        tmp.setFullName(user.getFullName());
        tmp.setPhoneNumber(user.getPhoneNumber());
        tmp.setEmail(user.getEmail());
        tmp.setAddress(user.getAddress());

        userService.editUser(tmp);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Cập nhật thành công!");

        return ResponseEntity.ok().body(response);
    }
    
    @PostMapping("/delete/{id}")
    public ResponseEntity<Map<String, String>> deleteById(@PathVariable Long id) {
        User user = userService.getUserById(id).get();
        user.setStatus(0);
        userService.saveUser(user);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Xóa người dùng thành công!");
        return ResponseEntity.ok().body(response);
    }
    
    @PostMapping(value = "/update-avatar", consumes = "multipart/form-data")
    public String updateAvatar(@RequestParam("image") MultipartFile imageFile,
                                HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        User user = userService.getUserById(currentUser.getId()).get();
        if (!imageFile.isEmpty()) {
            try {
                String fileName = imageFile.getOriginalFilename();
                String uploadDir = "src/main/resources/static/uploads/user/";
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Files.copy(imageFile.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
                user.setImageUrl("/uploads/user/" + fileName);
            } catch (Exception e) {
                
            }
        }
        userService.saveUser(user);
        return "";
    }
    
}
