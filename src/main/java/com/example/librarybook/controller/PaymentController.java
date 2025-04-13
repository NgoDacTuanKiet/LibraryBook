package com.example.librarybook.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.DTO.PaymentResponseDTO;
import com.example.librarybook.model.Book;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.Employee;
import com.example.librarybook.model.Payment;
import com.example.librarybook.model.PaymentDetail;
import com.example.librarybook.model.User;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.PaymentService;
import com.example.librarybook.services.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;



@RestController
@RequestMapping("/api/payment")
public class PaymentController {
    private Map<Long, List<PaymentResponseDTO>> tmpPaymentResponse = new HashMap<>();

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private BookService bookService;

    @PostMapping("/add/{customerId}")
    public ResponseEntity<Map<String, String>> postMethodName(@RequestBody List<PaymentResponseDTO> paymentResponseDTOs, @PathVariable Long customerId, HttpSession session) {
        Map<String, String> response = new HashMap<>();
        User tmp = (User) session.getAttribute("user");
        User user = userService.getUserById(tmp.getId()).get();
        Employee employee = user.getEmployee();
        Customer customer = customerService.getCustomerById(customerId);

        Long punishCost = 0L;
        Long bookFee = 0L;
        List<PaymentDetail> paymentDetails = new ArrayList<>();
        for(PaymentResponseDTO i: paymentResponseDTOs){
            PaymentDetail paymentDetail = new PaymentDetail();
            Book book = bookService.getBookByID(i.getBookId());
            paymentDetail.setBook(book);
            paymentDetail.setBookLoanDate(i.getBookLoanDate());
            paymentDetail.setDueDate(i.getDueDate());
            paymentDetail.setPunishCost(i.getPunishCost());
            paymentDetail.setReason(i.getReason());
            paymentDetail.setQuantity(i.getQuantity());
            paymentDetails.add(paymentDetail);

            punishCost += i.getPunishCost();
            bookFee += i.getQuantity()*10000;
        }

        Payment payment = new Payment();
        payment.setCustomer(customer);
        payment.setEmployee(employee);
        payment.setTime(LocalDateTime.now());
        payment.setBookFee(bookFee);
        payment.setPunish(punishCost);
        payment.setPaymentDetails(paymentDetails);
        
        paymentService.save(payment);

        response.put("message", "");
        return ResponseEntity.ok().body(response);
    }
    
    @PostMapping("/new/detail/{userId}")
    public ResponseEntity<List<PaymentResponseDTO>> postMethodName(@RequestBody List<PaymentResponseDTO> paymentResponseDTOs, @PathVariable Long userId) {
        tmpPaymentResponse.put(userId, paymentResponseDTOs);
        return ResponseEntity.ok().body(paymentResponseDTOs);
    }
    
    @GetMapping("/temp/detail/{userId}")
    public ResponseEntity<List<PaymentResponseDTO>> getTempPayment(@RequestParam Long userId) {
        List<PaymentResponseDTO> paymentResponseDTOs = tmpPaymentResponse.getOrDefault(userId, new ArrayList<>());
        return ResponseEntity.ok().body(paymentResponseDTOs);
    }
}
