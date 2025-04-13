package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.Book;

@Repository
public interface FavoriteBookRepository extends JpaRepository<Book, Long> {
    @Query(
        "SELECT COUNT(fb) > 0 " +
        "FROM Customer as c " +
        "JOIN c.favoriteBooks fb " +
        "WHERE c.id = :customerID " +
        "AND fb.id = :bookID"
    )
    boolean existsByCustomerIdAndBookID(@Param("customerID") Long CustomerId, @Param("bookID") Long BookId);
 
}
