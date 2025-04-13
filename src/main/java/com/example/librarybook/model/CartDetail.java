package com.example.librarybook.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "CartDetail")
public class CartDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "bookID")
    private Book book;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "CartCustomerID")
    private Cart cart;

    @Column(name = "quantity")
    private Long quantity;
}
