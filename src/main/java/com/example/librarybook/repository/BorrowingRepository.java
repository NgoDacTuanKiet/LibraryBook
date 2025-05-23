package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.Borrowing;

@Repository
public interface BorrowingRepository extends JpaRepository<Borrowing, Long>{

}
