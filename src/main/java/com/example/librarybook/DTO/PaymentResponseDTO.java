package com.example.librarybook.DTO;

import java.time.LocalDateTime;

import com.example.librarybook.model.Book;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaymentResponseDTO {
    private Book book;
    private LocalDateTime bookLoanDate;
    private LocalDateTime dueDate;
    private Long quantity;
    private Long punishCost;
    private String reason;
    private Long total;

    public PaymentResponseDTO(Book book, LocalDateTime bookLoanDate, LocalDateTime dueDate, Long quantity, Long punishCost, String reason, Long total){
        this.book = book;
        this.bookLoanDate = bookLoanDate;
        this.dueDate = dueDate;
        this.quantity = quantity;
        this.punishCost = punishCost;
        this.reason = reason;
        this.total = total;
    }
}
