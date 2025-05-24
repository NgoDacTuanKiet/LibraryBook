package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.Comment;
import com.example.librarybook.repository.CommentRepository;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;

    public Comment saveComment(Comment comment){
        return commentRepository.save(comment);
    }

    public Comment findCommentById(Long id){
        return commentRepository.findById(id).get();
    }

    public void deleteComment(Long id){
        commentRepository.deleteById(id);
    }
}
