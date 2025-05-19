package com.example.librarybook.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.Payment;
import com.example.librarybook.repository.PaymentRepository;

@Service
public class PaymentService {
    @Autowired
    private PaymentRepository paymentRepository;
    
    public Payment save(Payment payment){
        return paymentRepository.save(payment);
    }

    public List<Payment> getAllPayments(){
        return paymentRepository.findAll();
    }

    public Payment findById(Long id){
        return paymentRepository.findById(id).get();
    }

    public List<Payment> findPaymentByRequest(String customerFullName, String customerPhoneNumber, String emplyeeFullName){
        return paymentRepository.findPaymentByRequest(customerFullName, customerPhoneNumber, emplyeeFullName);
    }
}