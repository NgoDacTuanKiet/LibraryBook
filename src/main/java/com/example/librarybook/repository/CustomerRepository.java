package com.example.librarybook.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.librarybook.model.Customer;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Integer> {
    //Tìm kiếm khách hàng theo từ khóa tên
    List<Customer> findByUser_FullNameContaining(String keyword);

    Customer findById(Long id);

    Customer findByFavoriteBooks_Id(long bookId);

    Customer findByUser_Id(Long user_Id);
}
