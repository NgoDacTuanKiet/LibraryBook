package com.example.librarybook.repository;

import java.util.List;

import com.example.librarybook.model.Book;

public interface BookRepositoryCustom {
    List<Book> findBookByRequest(String bookName, String publisher, String author, String year, List<Long> categories, Integer status, Long offset, Long pageSize);

    Long findBookCountByRequest(String bookName, String publisher, String author, String year, List<Long> categories, Integer status);
}
