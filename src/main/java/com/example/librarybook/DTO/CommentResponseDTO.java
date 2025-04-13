package com.example.librarybook.DTO;

import java.util.List;

import com.example.librarybook.model.Comment;
import com.example.librarybook.model.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentResponseDTO {
    private User user;
    private List<Comment> comments;

    public CommentResponseDTO(User user, List<Comment> comments) {
        this.user = user;
        this.comments = comments;
    }
}
