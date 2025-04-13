package com.example.librarybook.model;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "Customer")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // ID tự động tăng
    private Long id;

    @OneToOne
    @JoinColumn(name = "UserID")
    private User user;
    
    @JsonIgnore
    @OneToOne(mappedBy = "customer", cascade = {CascadeType.MERGE, CascadeType.PERSIST})
    private Cart cart;

    @JsonIgnore
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "favoriteBook",
        joinColumns = @JoinColumn(name = "customerID"),
        inverseJoinColumns = @JoinColumn(name = "bookID")
    )
    private List<Book> favoriteBooks = new ArrayList<>();

    @JsonIgnore
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "bookBorrowed",
        joinColumns = @JoinColumn(name = "customerID"),
        inverseJoinColumns = @JoinColumn(name = "bookID")
    )
    private List<Book> bookBorroweds = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "customer", cascade = {CascadeType.PERSIST, CascadeType.MERGE},fetch = FetchType.LAZY)
    private List<BookBorrowing> booksBorrowings = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "customer", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    private List<Borrowing> borrowings = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY)
    private List<Comment> comments = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY)
    private List<Payment> payments = new ArrayList<>();
}
