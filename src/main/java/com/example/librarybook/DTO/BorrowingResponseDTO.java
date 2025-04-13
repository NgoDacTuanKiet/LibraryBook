package com.example.librarybook.DTO;

import java.util.List;

import com.example.librarybook.model.Borrowing;
import com.example.librarybook.model.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BorrowingResponseDTO {
    private User user;
    private List<Borrowing> borrowings;
    
    public BorrowingResponseDTO(User user, List<Borrowing> borrowings){
        this.user = user;
        this.borrowings = borrowings;
    }
}
