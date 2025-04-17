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
@Table(name = "Book")
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "bookName", columnDefinition = "NVARCHAR(100)")
    private String bookName;

    @Column(name = "publisher",columnDefinition = "NVARCHAR(50)")
    private String publisher;

    @Column(name = "author", columnDefinition = "NVARCHAR(50)")
    private String author;

    @Column(name = "quantity", nullable = true)
    private Long quantity;

    @Column(name = "availableQuantity", nullable = true)
    private Long availableQuantity;

    @Column(name = "yearOfpublication", nullable = true)
    private String yearOfpublication;

    @Column(name = "status", nullable = true)
    private Integer status;

    @Column(name = "describe", columnDefinition = "NVARCHAR(1000)")
    private String describe; //mô tả

    @Column(name = "imageUrl",columnDefinition = "NVARCHAR(100)", nullable = true)
    private String imageUrl; // Lưu đường dẫn ảnh

    @ManyToMany(mappedBy = "favoriteBooks", fetch = FetchType.LAZY)
    private List<Customer> likedByCustomers = new ArrayList<>();

    @ManyToMany(mappedBy = "bookBorroweds", fetch = FetchType.LAZY)
    private List<Customer> borrowedByCustomers = new ArrayList<>();
    
    @ManyToMany(mappedBy = "booksOfCategory",cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    private List<Category> categoriesOfBook = new ArrayList<>();
    
    @JsonIgnore
    @OneToMany(mappedBy = "book", cascade = {CascadeType.MERGE, CascadeType.PERSIST}, fetch = FetchType.LAZY)
    private List<BookBorrowing> bookBorrowings = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "book", fetch = FetchType.LAZY)
    private List<BorrowDetail> borrowDetails = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "book", fetch = FetchType.LAZY)
    private List<CartDetail> cartDetails = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "book", fetch = FetchType.LAZY)
    private List<Comment> comments = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "book", fetch = FetchType.LAZY)
    private List<PaymentDetail> paymentDetails = new ArrayList<>();
}
