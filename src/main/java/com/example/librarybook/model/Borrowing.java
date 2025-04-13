package com.example.librarybook.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
@Table(name = "Borrowing")
public class Borrowing {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // ID tự động tăng
    private Long id;

   @Column(name = "borrowedDate", nullable = true)
   private LocalDateTime borrowDate;

   @ManyToOne
   @JoinColumn(name = "customerID")
   private Customer customer;

   @OneToMany(mappedBy = "borrowing", cascade = {CascadeType.MERGE, CascadeType.PERSIST}, fetch = FetchType.LAZY)
   private List<BorrowDetail> borrowDetails = new ArrayList<>();
}
