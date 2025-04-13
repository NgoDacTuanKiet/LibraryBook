package com.example.librarybook.DTO;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaymentResponseDTO {
    private Long bookId;
    private LocalDateTime bookLoanDate;
    private LocalDateTime dueDate;
    private Long quantity;
    private Long punishCost;
    private String reason;

    public PaymentResponseDTO(Long bookId, LocalDateTime bookLoanDate, LocalDateTime dueDate, Long quantity, Long punishCost, String reason){
        this.bookId = bookId;
        this.bookLoanDate = bookLoanDate;
        this.dueDate = dueDate;
        this.quantity = quantity;
        this.punishCost = punishCost;
        this.reason = reason;
    }
}
