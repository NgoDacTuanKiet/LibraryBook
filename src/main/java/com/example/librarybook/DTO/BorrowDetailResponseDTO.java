package com.example.librarybook.DTO;

import java.util.List;

import com.example.librarybook.model.BorrowDetail;
import com.example.librarybook.model.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BorrowDetailResponseDTO {
    private User user;
    private List<BorrowDetail> borrowDetails;

    public BorrowDetailResponseDTO( User user, List<BorrowDetail> borrowDetails){
        this.user = user;
        this.borrowDetails = borrowDetails;
    }
}
