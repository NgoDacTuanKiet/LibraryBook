package com.example.librarybook.DTO;

import java.time.LocalDateTime;
import java.util.List;

import com.example.librarybook.model.PaymentDetail;
import com.example.librarybook.model.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InvoiceResponseDTO {
    private Long paymentId;
    private List<PaymentDetail> paymentDetails;
    private User customer_user;
    private User employee_user;
    private LocalDateTime time;

    public InvoiceResponseDTO(Long paymentId, List<PaymentDetail> paymentDetails, User customer_user, User employee_user, LocalDateTime time){
        this.paymentId = paymentId;
        this.paymentDetails = paymentDetails;
        this.customer_user = customer_user;
        this.employee_user = employee_user;
        this.time = time;
    }
}
