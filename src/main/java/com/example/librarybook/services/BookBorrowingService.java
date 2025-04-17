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
        BookBorrowing  bookBorrowing = bookBorrowedRepository.findByBook_IdAndCustomer_Id(bookId, customerId);
        if (bookBorrowing == null){
            bookBorrowing = new BookBorrowing();
            bookBorrowing.setQuantity(0L);
        }
        return bookBorrowing;
    }

    public BookBorrowing save(BookBorrowing bookBorrowing){
        return bookBorrowedRepository.save(bookBorrowing);
    }

    public void deleteById(Long id){
        bookBorrowedRepository.deleteById(id);
    }
}
