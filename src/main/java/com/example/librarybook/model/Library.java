package com.example.librarybook.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "Library")
public class Library {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "address", columnDefinition = "NVARCHAR(100)", nullable = true)
    private String address;

    @Column(name = "phoneNumber", length = 15, nullable = true)
    private String phoneNumber;

    @Column(name = "email", length = 50, nullable = true)
    private String email;

    @JsonIgnore
    @OneToMany(mappedBy = "library", cascade = {CascadeType.MERGE, CascadeType.PERSIST}, fetch = FetchType.LAZY)
    private List<Employee> listEmployees;

    @JsonIgnore
    @OneToMany(mappedBy = "library", fetch = FetchType.LAZY)
    private List<Book> books;

}
