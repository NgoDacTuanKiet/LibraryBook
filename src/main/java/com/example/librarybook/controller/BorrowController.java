package com.example.librarybook.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.DTO.BorrowDetailResponseDTO;
import com.example.librarybook.DTO.BorrowingResponseDTO;
import com.example.librarybook.model.Book;
import com.example.librarybook.model.BookBorrowing;
import com.example.librarybook.model.BorrowDetail;
import com.example.librarybook.model.Borrowing;
import com.example.librarybook.model.Cart;
import com.example.librarybook.model.CartDetail;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.services.BookBorrowingService;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.BorrowingService;
import com.example.librarybook.services.CartService;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.UserService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/borrow")
public class BorrowController {
    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private BorrowingService borrowingService;

    @Autowired
    private CartService cartService;

    @Autowired
    private BookBorrowingService bookBorrowingService;

    @Autowired
    private BookService bookService;

    @PostMapping("/borrowaction")
    public ResponseEntity<Map<String, String>> borrow(HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        
        Cart cart = customer.getCart();
        List<CartDetail> cartDetails = cart.getCartDetails();

        Borrowing borrowing = new Borrowing();
        borrowing.setBorrowDate(LocalDateTime.now());
        borrowing.setCustomer(customer);

        List<BorrowDetail> borrowDetails = new ArrayList<>();
        List<BookBorrowing> bookBorrowings = new ArrayList<>();
        List<Book> bookBorroweds = customer.getBookBorroweds();

        for(CartDetail i : cartDetails){
            BorrowDetail borrowDetail = new BorrowDetail();
            borrowDetail.setBook(i.getBook());
            borrowDetail.setQuantity(i.getQuantity());
            borrowDetail.setBorrowing(borrowing);
            borrowDetails.add(borrowDetail);

            Book book = i.getBook();
            book.setAvailableQuantity(book.getAvailableQuantity() - i.getQuantity());
            bookService.saveBook(book);
            
            BookBorrowing bookBorrowing = bookBorrowingService.findByBookIdAndCustomerId(i.getBook().getId(), customer.getId());
            bookBorrowing.setBook(i.getBook());
            bookBorrowing.setCustomer(customer);
            bookBorrowing.setDueDate(LocalDateTime.now().plusDays(30));
            bookBorrowing.setQuantity(bookBorrowing.getQuantity() + i.getQuantity());
            if(bookBorrowing.getQuantity() == 0){
                bookBorrowing.setBookLoanDate(LocalDateTime.now());
            }
            bookBorrowings.add(bookBorrowing);

            if(!bookBorroweds.contains(i.getBook())){
                bookBorroweds.add(i.getBook());
            }
        }
        
        customer.setBookBorroweds(bookBorroweds);
        customer.setBooksBorrowings(bookBorrowings);
        customerService.saveCustomer(customer);

        borrowing.setBorrowDetails(borrowDetails);
        borrowingService.save(borrowing);
        
        cartService.deleteAllCartDetail(cart);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Đã mượn sách!");
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/borrowing/list")
    public ResponseEntity<BorrowingResponseDTO> getList(HttpSession session) {
        User tmp = (User) session.getAttribute("user");

        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        User user = customer.getUser();
        List<Borrowing> borrowings = customer.getBorrowings();
        Collections.reverse(borrowings);
        return ResponseEntity.ok().body(new BorrowingResponseDTO(user, borrowings));
    }
    
    @GetMapping("/borrowing/detail/{borrowingId}")
    public ResponseEntity<BorrowDetailResponseDTO> getBorrowingDetail(@PathVariable Long borrowingId, HttpSession session) {
        User tmp = (User) session.getAttribute("user");

        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        User user = customer.getUser();
        Borrowing borrowing = borrowingService.findById(borrowingId);
        List<BorrowDetail> borrowDetails = borrowing.getBorrowDetails();

        BorrowDetailResponseDTO borrowDetailResponseDTO = new BorrowDetailResponseDTO(user, borrowDetails);
        return ResponseEntity.ok().body(borrowDetailResponseDTO);
    }
    
    @GetMapping("/borrowing/book/list")
    public ResponseEntity<List<BookBorrowing>> getbookBorrowingList(HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());

        List<BookBorrowing> bookBorrowings = customer.getBooksBorrowings();
        
        return ResponseEntity.ok(bookBorrowings);
    }

    @GetMapping("/borrowing/book/list/{userId}")
    public ResponseEntity<List<BookBorrowing>> getbookBorrowingListByUserId(@PathVariable Long userId) {
        User tmp = userService.getUserById(userId).get();
        Customer customer = customerService.getCustomerByUserId(tmp.getId());

        List<BookBorrowing> bookBorrowings = customer.getBooksBorrowings();
        
        return ResponseEntity.ok(bookBorrowings);
    }

    @GetMapping("/borrowed/book/list")
    public ResponseEntity<List<Book>> getBookBorrowedList(HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());

        List<Book> bookBorroweds = customer.getBookBorroweds();
        return ResponseEntity.ok(bookBorroweds);
    }
    
    @GetMapping("/borrowing/customer/list")
    public ResponseEntity<List<User>> getCustomerBorrowinList() {
        List<User> users = new ArrayList<>();
        List<User> allUsers = userService.getAllUsers();
        for(User i: allUsers){
            if(i.getCustomer() == null){
                continue;
            }
            if( i.getCustomer().getBooksBorrowings().size() > 0){
                users.add(i);
            }
        }
        return ResponseEntity.ok(users);
    }
    
}
