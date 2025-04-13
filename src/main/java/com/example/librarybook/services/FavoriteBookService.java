package com.example.librarybook.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.Book;
import com.example.librarybook.model.Customer;
import com.example.librarybook.repository.BookRepository;
import com.example.librarybook.repository.CustomerRepository;
import com.example.librarybook.repository.FavoriteBookRepository;

@Service
public class FavoriteBookService {
    @Autowired
    private FavoriteBookRepository favoriteBookRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public boolean isFavoriteBook(Long customerId, Long bookId){
        return favoriteBookRepository.existsByCustomerIdAndBookID(customerId, bookId);
    }

    public boolean toggleFavorite(Long userId, Long bookId) {
        Customer currentCustomer = customerRepository.findByUser_Id(userId);
        if (isFavoriteBook(currentCustomer.getId(), bookId)) {
            Book tmp = bookRepository.findById(bookId).get();
// findByCustomer_Id
            List<Book> favoriteBooks = currentCustomer.getFavoriteBooks();
            favoriteBooks.remove(tmp);
            customerRepository.save(currentCustomer);
            return false;
        } else {
            Book tmp = bookRepository.findById(bookId).get();
            List<Book> favoriteBooks = currentCustomer.getFavoriteBooks();
            favoriteBooks.add(tmp);
            customerRepository.save(currentCustomer);
            return true;
        }
    }
}
