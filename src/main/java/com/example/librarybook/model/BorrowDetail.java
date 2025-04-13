package com.example.librarybook.model;

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
@Table(name = "BorrowDetail")
public class BorrowDetail {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "borrowingID")
    private Borrowing borrowing;

    @ManyToOne
    @JoinColumn(name = "BookID")
    private Book book;

    @Column(name = "quantity")
    private Long quantity;
}
