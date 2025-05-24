package com.example.librarybook.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.librarybook.model.Payment;

public interface PaymentReopsitoryCustom {
    Page<Payment> findPaymentByRequest(String customerFullName, String customerPhoneNumber, String employeeFullName, Pageable pageable);
}
