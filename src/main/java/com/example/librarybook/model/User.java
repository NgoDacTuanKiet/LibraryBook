package com.example.librarybook.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor // Constructor không tham số (cần cho JPA)
@AllArgsConstructor // Constructor đầy đủ tham số
@Table(name = "Users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username", length = 50)
    private String username;

    @Column(name = "password", columnDefinition = "VARCHAR(100)", nullable = true)
    private String password;

    @Column(name ="fullName", columnDefinition = "NVARCHAR(50)")
    private String fullName;

    @Column(name = "phoneNumber" ,length = 15, unique = true)
    private String phoneNumber;

    @Column(name = "email" ,length = 50, unique = true)
    private String email;

    @Column(name = "address", columnDefinition = "NVARCHAR(100)")
    private String address;

    @Column(name = "status", nullable = true)
    private Integer status;

    @Column(name = "imageUrl", nullable = true)
    private String imageUrl; // Lưu đường dẫn ảnh

    @Column(name = "role", length = 20, nullable = true)
    private String role;

    @JsonIgnore
    @OneToOne(mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private Customer customer;

    @JsonIgnore
    @OneToOne(mappedBy = "user", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private Employee employee;
}
