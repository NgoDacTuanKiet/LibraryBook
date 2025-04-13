package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.Borrowing;
import com.example.librarybook.repository.BorrowingRepository;

@Service
public class BorrowingService {
    @Autowired
    private BorrowingRepository borrowingRepository;

    public Borrowing save(Borrowing borrowing){
        return borrowingRepository.save(borrowing);
    }

    public Borrowing findById(Long id){
        return borrowingRepository.findById(id).get();
    }
}
