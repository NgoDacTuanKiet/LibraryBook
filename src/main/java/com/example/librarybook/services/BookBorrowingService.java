package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.BookBorrowing;
import com.example.librarybook.repository.BookBorrowingRepository;

@Service
public class BookBorrowingService {
    @Autowired
    private BookBorrowingRepository bookBorrowedRepository;

    public BookBorrowing findByBookIdAndCustomerId(Long bookId,Long customerId){
        BookBorrowing  bookBorrowed = bookBorrowedRepository.findByBook_IdAndCustomer_Id(bookId, customerId);
        if (bookBorrowed == null){
            bookBorrowed = new BookBorrowing();
            bookBorrowed.setQuantity(0L);
        }
        return bookBorrowed;
    }
}
