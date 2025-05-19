package com.example.librarybook.services;

import com.example.librarybook.model.Book;
import com.example.librarybook.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookService {
    @Autowired
    private BookRepository bookRepository;

    // lấy danh sách sách
    public List<Book> getAllBooks(){
        return bookRepository.findAll();
    }

    public Book getBookByID(Long id){
        return bookRepository.findById(id).get();
    }
    // Tìm sách theo tên
    public List<Book> getBookByName(String keyword){
        return bookRepository.findByBookNameContaining(keyword);
    }

    // Thêm hoặc cập nhật sách
    public Book saveBook(Book book){
        return bookRepository.save(book);
    }

    public List<Book> searchBooks(String bookName, String publisher, String author, String yearOfpublication, List<Long> categories, Integer status, Long offset, Long pageSize) {
        return bookRepository.findBookByRequest(bookName, publisher, author, yearOfpublication, categories, status, offset, pageSize);
    }

    public Long findBookCountByRequest(String bookName, String publisher, String author, String yearOfpublication, List<Long> categories, Integer status){
        return bookRepository.findBookCountByRequest(bookName, publisher, author, yearOfpublication, categories, status);
    }

    public void deleteById(Long id){
        bookRepository.deleteById(id);
    }
}