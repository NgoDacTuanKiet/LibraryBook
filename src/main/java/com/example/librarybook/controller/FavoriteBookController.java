package com.example.librarybook.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.model.Book;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.FavoriteBookService;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;


@RestController
@RequestMapping("/api/favorite")
public class FavoriteBookController {
    @Autowired
    private FavoriteBookService favoriteBookService;

    @Autowired
    private CustomerService customerService;

    @GetMapping("/check/{bookId}")
    public boolean isBookFavorited(@PathVariable Long bookId, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(currentUser.getId());
        return favoriteBookService.isFavoriteBook(customer.getId(), bookId);
    }

    @PostMapping("/toggle/{bookId}")
    public ResponseEntity<Boolean> toggleFavorite(@PathVariable Long bookId, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        boolean isNowFavorited = favoriteBookService.toggleFavorite(currentUser.getId(), bookId);
        return ResponseEntity.ok(isNowFavorited);
    }

    @GetMapping("/list")
    public ResponseEntity<List<Book>> listFavoriteBook(HttpSession session) {
        User user = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(user.getId());
        List<Book> favoritesBooks = customer.getFavoriteBooks();
        return ResponseEntity.ok(favoritesBooks);
    }
    
}
