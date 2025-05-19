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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.DTO.BorrowDetailResponseDTO;
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
            if(bookBorrowing.getQuantity() == 0L){
                bookBorrowing.setBookLoanDate(LocalDateTime.now());
            }
            bookBorrowing.setQuantity(bookBorrowing.getQuantity() + i.getQuantity());
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
    public ResponseEntity<Map<String, Object>> getList(HttpSession session,
                                                        @RequestParam Long page,
                                                        @RequestParam Long pageSize) {
        User tmp = (User) session.getAttribute("user");

        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        User user = customer.getUser();
        List<Borrowing> borrowings = customer.getBorrowings();
        Collections.reverse(borrowings);
        Long totalBorrowings = borrowings.size()*1L;
        Long totalPages = totalBorrowings / pageSize;
        if(totalPages * pageSize < totalBorrowings)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if(end > totalBorrowings - 1)
            end = totalBorrowings - 1;
        List<Borrowing> responseBorrowings = new ArrayList<>();
        for(Long i = start; i <= end; i++)
            responseBorrowings.add(borrowings.get(i.intValue()));
        Map<String, Object> result = new HashMap<>();
        result.put("borrowings", responseBorrowings);
        result.put("totalPages", totalPages);
        result.put("user", user);
        return ResponseEntity.ok().body(result);
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
    public ResponseEntity<Map<String, Object>> getbookBorrowingList(HttpSession session,
                                                                    @RequestParam Long page,
                                                                    @RequestParam Long pageSize) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        
        List<BookBorrowing> bookBorrowingsALL = customer.getBooksBorrowings();

        Long totalBookBorrowing = bookBorrowingsALL.size()*1L;
        Long totalPages = totalBookBorrowing / pageSize;
        if (totalPages * pageSize < totalBookBorrowing)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalBookBorrowing - 1)
            end = totalBookBorrowing - 1;
        List<BookBorrowing> bookBorrowings = new ArrayList<>();
        for(Long i = start; i <= end; i++){
            bookBorrowings.add(bookBorrowingsALL.get(i.intValue()));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("bookBorrowings", bookBorrowings);
        result.put("totalPages", totalPages);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/borrowing/book/list/{userId}")
    public ResponseEntity<List<BookBorrowing>> getbookBorrowingListByUserId(@PathVariable Long userId) {
        User tmp = userService.getUserById(userId).get();
        Customer customer = customerService.getCustomerByUserId(tmp.getId());

        List<BookBorrowing> bookBorrowings = customer.getBooksBorrowings();
        
        return ResponseEntity.ok(bookBorrowings);
    }

    @GetMapping("/borrowed/book/list")
    public ResponseEntity<Map<String, Object>> getBookBorrowedList(HttpSession session,
                                                        @RequestParam Long page,
                                                        @RequestParam Long pageSize) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());

        List<Book> bookBorrowedsALL = customer.getBookBorroweds();

        Long totalBooks = bookBorrowedsALL.size()*1L;
        Long totalPages = totalBooks / pageSize;
        if (totalPages * pageSize < totalBooks)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalBooks - 1)
            end = totalBooks - 1;
        List<Book> bookBorroweds = new ArrayList<>();
        for(Long i = start; i <= end; i++){
            bookBorroweds.add(bookBorrowedsALL.get(i.intValue()));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("bookBorroweds", bookBorroweds);
        result.put("totalPages", totalPages);
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("/borrowing/customer/list")
    public ResponseEntity<Map<String, Object>> getCustomerBorrowinList(@RequestParam Long page,
                                                                       @RequestParam Long pageSize) {
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
        Long totalUsers = users.size()*1L;
        Long totalPages = totalUsers / pageSize;
        if (totalPages * pageSize < totalUsers)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalUsers - 1)
            end = totalUsers - 1;
        List<User> responseUsers = new ArrayList<>();
        for(Long i = start; i <= end; i++){
            responseUsers.add(users.get(i.intValue()));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("users", responseUsers);
        result.put("totalPages", totalPages);
        return ResponseEntity.ok(result);
    }
    
}
