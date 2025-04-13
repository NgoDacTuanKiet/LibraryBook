package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.BookBorrowing;

@Repository
public interface BookBorrowingRepository extends JpaRepository<BookBorrowing, Long> {
    BookBorrowing findByBook_IdAndCustomer_Id(Long bookId, Long customerId);
}
