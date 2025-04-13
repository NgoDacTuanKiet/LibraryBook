package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.Payment;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long>{
    
}
