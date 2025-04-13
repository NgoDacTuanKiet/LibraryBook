package com.example.librarybook.model;

import java.time.LocalDateTime;

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
@Table(name = "Comment")
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "customerID")
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "bookID")
    private Book book;

    @Column(name = "content", columnDefinition = "NVARCHAR(1000)")
    private String content;

    @Column(name = "time")
    private LocalDateTime time;

    @Column(name = "username", length = 50)
    private String username;
}
