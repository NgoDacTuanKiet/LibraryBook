package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.Comment;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long>{

}
