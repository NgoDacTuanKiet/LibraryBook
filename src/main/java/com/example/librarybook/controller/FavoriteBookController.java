package com.example.librarybook.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.model.Book;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.FavoriteBookService;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
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
    public ResponseEntity<Map<String, Object>> listFavoriteBook(HttpSession session,
                                                        @RequestParam Long page,
                                                        @RequestParam Long pageSize) {
        User user = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(user.getId());
        List<Book> books = customer.getFavoriteBooks();
        Long totalBooks = books.size()*1L;
        Long totalPages = totalBooks / pageSize;
        if (totalPages * pageSize < totalBooks)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalBooks - 1)
            end = totalBooks - 1;
        List<Book> favoritesBooks = new ArrayList<>();
        for(Long i = start; i <= end; i++){
            favoritesBooks.add(books.get(i.intValue()));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("favoriteBooks", favoritesBooks);
        result.put("totalPages", totalPages);
        return ResponseEntity.ok(result);
    }
    
}
