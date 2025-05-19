package com.example.librarybook.repository;

import java.util.List;
import java.util.stream.Collectors;

import com.example.librarybook.model.Book;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class BookRepositoryImpl implements BookRepositoryCustom {

    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    @Override
    public List<Book> findBookByRequest(String bookName, String publisher, String author, String yearOfpublication, List<Long> categories, Integer status, Long offset, Long pageSize) {
        StringBuilder sql = new StringBuilder("SELECT b.id, b.bookName, b.publisher, b.author, b.yearOfpublication, b.quantity, b.availableQuantity, b.describe, b.imageURL, b.status");
        selectSQL(categories, sql);
        sql.append(" FROM Book as b ");
        joinTable(categories, sql);

        StringBuilder where = new StringBuilder(" WHERE 1=1 ");
        queryNomal(bookName, publisher, author, yearOfpublication, status, where);
        querySpecial(categories, where);
        where.append(" GROUP BY b.id, b.bookName, b.publisher, b.author, b.yearOfpublication, b.quantity, b.availableQuantity, b.describe, b.imageURL, b.status");
        sql.append(where);
        sql.append(" ORDER BY b.id DESC");
        sql.append(" OFFSET ").append(offset).append(" ROWS FETCH NEXT ").append(pageSize).append(" ROWS ONLY");
        Query query = entityManager.createNativeQuery(sql.toString(), Book.class);
        return query.getResultList();
    }

    @Override
    public Long findBookCountByRequest(String bookName, String publisher, String author, String yearOfpublication, List<Long> categories, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*)");
        selectSQL(categories, sql);
        sql.append(" FROM Book as b ");
        joinTable(categories, sql);

        StringBuilder where = new StringBuilder(" WHERE 1=1 ");
        queryNomal(bookName, publisher, author, yearOfpublication, status, where);
        querySpecial(categories, where);

        Query query = entityManager.createNativeQuery(sql.toString());
        Number countResult = (Number) query.getSingleResult();
        return countResult.longValue();
    }

    private void selectSQL(List<Long> categories, StringBuilder sql){
        if (categories != null && !categories.isEmpty()) {
            sql.append(", STRING_AGG(bookCategory.categoryID, ', ') AS categories ");
        }
    }

    private void joinTable(List<Long> categories, StringBuilder sql) {
        if (categories != null && !categories.isEmpty()) {
            sql.append(" INNER JOIN bookCategory ON b.id = bookCategory.bookID ");
        }
    }

    private void queryNomal(String bookName, String publisher, String author, String yearOfpublication, Integer status, StringBuilder where) {
        if (bookName != null && !bookName.isEmpty()) {
            where.append(" AND b.bookName LIKE N'%").append(bookName).append("%' ");
        }
        if (publisher != null && !publisher.isEmpty()) {
            where.append(" AND b.publisher LIKE N'%").append(publisher).append("%' ");
        }
        if (author != null && !author.isEmpty()) {
            where.append(" AND b.author LIKE N'%").append(author).append("%' ");
        }
        if (yearOfpublication != null && !yearOfpublication.isEmpty()) {
            where.append(" AND b.yearOfpublication = '").append(yearOfpublication).append("' ");
        }
        where.append("AND b.status = ").append(status);
    }

    private void querySpecial(List<Long> categories, StringBuilder where) {
        if (categories != null && !categories.isEmpty()) {
            where.append(" AND b.id IN (SELECT bookID FROM bookCategory WHERE categoryID IN (");
            where.append(categories.stream().map(String::valueOf).collect(Collectors.joining(", ")));
            where.append(")) ");
        }
    }
}
