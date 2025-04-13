package com.example.librarybook.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.DTO.CommentResponseDTO;
import com.example.librarybook.model.Book;
import com.example.librarybook.model.Comment;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.CommentService;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.UserService;

import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private BookService bookService;

    @Autowired
    private UserService userService;

    @PostMapping("/{bookId}")
    public String comment(@PathVariable Long bookId, @RequestBody Comment comment, HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        User user = userService.getUserById(tmp.getId()).get();
        Customer customer = customerService.getCustomerByUserId(user.getId());
        Book book = bookService.getBookByID(bookId);
        Comment newComment = new Comment();
        newComment.setBook(book);
        newComment.setCustomer(customer);
        newComment.setContent(comment.getContent());
        newComment.setTime(LocalDateTime.now());
        newComment.setUsername(user.getUsername());

        book.getComments().add(newComment);

        customer.getComments().add(newComment);

        commentService.saveComment(newComment);
        return "";
    }
    
    @GetMapping("/list/{bookId}")
    public ResponseEntity<CommentResponseDTO> getComment(@PathVariable Long bookId, HttpSession session) {
        Book book = bookService.getBookByID(bookId);
        List<Comment> comments = book.getComments();
        User tmp = (User) session.getAttribute("user");
        User currentUser = userService.getUserById(tmp.getId()).get();
        CommentResponseDTO responseDTO = new CommentResponseDTO(currentUser, comments);
        return ResponseEntity.ok(responseDTO);
    }
    
}
