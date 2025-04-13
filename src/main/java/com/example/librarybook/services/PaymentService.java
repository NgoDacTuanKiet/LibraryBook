package com.example.librarybook.services;

// import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

// import com.example.librarybook.model.Customer;
import com.example.librarybook.model.Payment;
// import com.example.librarybook.repository.PaymentDetailRepository;
import com.example.librarybook.repository.PaymentRepository;

@Service
public class PaymentService {
    @Autowired
    private PaymentRepository paymentRepository;

    // @Autowired
    // private PaymentDetailRepository paymentDetailRepository;
    
    public Payment save(Payment payment){
        return paymentRepository.save(payment);
    }


}
    // public Payment getPaymentByCustomer(Customer customer){
    //     List<Payment> listPayments = customer.getPayments();
    //     for(int index = listPayments.size()-1; index >= 0; index--){
    //         Payment tmp = listPayments.get(index);
    //         if(tmp.getStatus() == 1){
    //             return tmp;
    //         }
    //     }
    //     Payment payment = new Payment();
    //     payment.setStatus(1L);
    //     return payment;
    // }