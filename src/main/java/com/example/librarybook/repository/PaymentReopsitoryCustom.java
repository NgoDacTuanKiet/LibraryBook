package com.example.librarybook.repository;

import java.util.List;

import com.example.librarybook.model.Payment;

public interface PaymentReopsitoryCustom {
    List<Payment> findPaymentByRequest(String customerFullName, String customerPhoneNumber, String employeeFullName);
}
