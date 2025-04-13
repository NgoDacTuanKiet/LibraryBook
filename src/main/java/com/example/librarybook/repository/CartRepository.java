package com.example.librarybook.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.librarybook.model.Cart;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long>{
    Cart findByCustomer_Id(Long customerId);
}
