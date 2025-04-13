package com.example.librarybook.repository;

import com.example.librarybook.model.Book;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends JpaRepository<Book, Long>, BookRepositoryCustom {
   
    // Tìm kiếm sách theo tù khóa tên
    List<Book> findByBookNameContaining(String keyword);
}
