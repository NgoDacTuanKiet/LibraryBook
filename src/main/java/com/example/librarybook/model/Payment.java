package com.example.librarybook.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
@Table(name = "Payment")
public class Payment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "employeeID")
    private Employee employee;

    @ManyToOne
    @JoinColumn(name = "customer")
    private Customer customer;

    @Column(name = "time")
    private LocalDateTime time;

    @Column(name = "bookFee")
    private Long bookFee;

    @Column(name = "punish")
    private Long punish;

    @OneToMany(mappedBy = "payment", fetch = FetchType.LAZY)
    private List<PaymentDetail> paymentDetails = new ArrayList<>();
}
