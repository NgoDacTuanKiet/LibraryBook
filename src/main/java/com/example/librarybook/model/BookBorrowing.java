package com.example.librarybook.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "BookBorrowing")
public class BookBorrowing {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "bookID", nullable = true)
    private Book book;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "customerID", nullable = true)
    private Customer customer;

    @Column(name = "bookLoanDate", nullable = true)
    private LocalDateTime bookLoanDate;

    @Column(name = "dueDate", nullable = true)
    private LocalDateTime dueDate; // Hạn

    @Column(name = "quantity", nullable = true)
    private Long quantity;
}
