package com.example.librarybook.model;

import java.time.LocalDateTime;

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
@Table(name = "PaymentDetail")
public class PaymentDetail {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // ID tự động tăng
    private Long id;

    @Column(name = "quantity")
    private Long quantity;

    @Column(name = "bookLoanDate")
    private LocalDateTime bookLoanDate;

    @Column(name = "dueDate")
    private LocalDateTime dueDate;

    @Column(name = "punishCost")
    private Long punishCost;

    @Column(name = "reason", columnDefinition = "NVARCHAR(100)")
    private String reason;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "paymentID")
    private Payment payment;

    @ManyToOne
    @JoinColumn(name = "bookID")
    private Book book;
}
