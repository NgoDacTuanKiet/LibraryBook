package com.example.librarybook.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.DTO.InvoiceResponseDTO;
import com.example.librarybook.DTO.PaymentResponseDTO;
import com.example.librarybook.model.Book;
import com.example.librarybook.model.BookBorrowing;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.Employee;
import com.example.librarybook.model.Payment;
import com.example.librarybook.model.PaymentDetail;
import com.example.librarybook.model.User;
import com.example.librarybook.services.BookBorrowingService;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.CustomerService;
import com.example.librarybook.services.PaymentService;
import com.example.librarybook.services.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;

@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
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

    @Autowired
    private BookBorrowingService bookBorrowingService;

    @PostMapping("/add/{customerId}")
    public ResponseEntity<Map<String, String>> postMethodName(@RequestBody List<PaymentResponseDTO> paymentResponseDTOs, @PathVariable Long customerId, HttpSession session) {
        Map<String, String> response = new HashMap<>();
        User tmp = (User) session.getAttribute("user");
        User user = userService.getUserById(tmp.getId()).get();
        Employee employee = user.getEmployee();
        Customer customer = customerService.getCustomerByUserId(customerId);

        Payment payment = new Payment();
        payment.setCustomer(customer);
        payment.setEmployee(employee);

        Long punishCost = 0L;
        Long bookFee = 0L;
        List<PaymentDetail> paymentDetails = new ArrayList<>();
        
        for(PaymentResponseDTO i: paymentResponseDTOs){
            PaymentDetail paymentDetail = new PaymentDetail();
            Book book = bookService.getBookByID(i.getBook().getId());
            paymentDetail.setBook(book);
            paymentDetail.setBookLoanDate(i.getBookLoanDate());
            paymentDetail.setDueDate(i.getDueDate());
            paymentDetail.setPunishCost(i.getPunishCost());
            paymentDetail.setReason(i.getReason());
            paymentDetail.setQuantity(i.getQuantity());
            paymentDetail.setPayment(payment);
            paymentDetails.add(paymentDetail);

            punishCost += i.getPunishCost();
            bookFee += i.getQuantity()*10000;

            book.setAvailableQuantity(book.getAvailableQuantity() + i.getQuantity());

            BookBorrowing bookBorrowing = bookBorrowingService.findByBookIdAndCustomerId(book.getId(), customer.getId());
            bookBorrowing.setQuantity(bookBorrowing.getQuantity() - i.getQuantity());
            bookBorrowingService.save(bookBorrowing);

            if(bookBorrowing.getQuantity() <= 0){
                bookBorrowingService.deleteById(bookBorrowing.getId());
            }
        }

        payment.setTime(LocalDateTime.now());
        payment.setBookFee(bookFee);
        payment.setPunish(punishCost);
        payment.setPaymentDetails(paymentDetails);
        
        paymentService.save(payment);
        tmpPaymentResponse.remove(customerId);
        response.put("message", "Thanh toán thành công");
        return ResponseEntity.ok().body(response);
    }
    
    @PostMapping("/new/detail/{customerId}")
    public ResponseEntity<List<PaymentResponseDTO>> postMethodName(@RequestBody List<PaymentResponseDTO> paymentResponseDTOs, @PathVariable Long customerId) {
        for(PaymentResponseDTO i: paymentResponseDTOs){
            LocalDate now = LocalDateTime.now().toLocalDate();
            LocalDate dueDate = i.getDueDate().toLocalDate();
            if(dueDate.isBefore(now)){
                long daysBetween = Math.abs(ChronoUnit.DAYS.between(now, dueDate));
                i.setTotal(i.getTotal() + daysBetween*1000);
                i.setReason(i.getReason() + ", muộn " + daysBetween + " ngày");
            }
        }
        tmpPaymentResponse.put(customerId, paymentResponseDTOs);
        return ResponseEntity.ok().body(paymentResponseDTOs);
    }
    
    @GetMapping("/temp/detail/{customerId}")
    public ResponseEntity<List<PaymentResponseDTO>> getTempPayment(@PathVariable Long customerId) {
        List<PaymentResponseDTO> paymentResponseDTOs = tmpPaymentResponse.getOrDefault(customerId, new ArrayList<>());
        return ResponseEntity.ok().body(paymentResponseDTOs);
    }

    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> getPaymentList(@RequestParam(required = false) String customerFullName,
                                                                   @RequestParam(required = false) String customerPhoneNumber,
                                                                   @RequestParam(required = false) String employeeFullName,
                                                                   @RequestParam Long page,
                                                                   @RequestParam Long pageSize) {
        Pageable pageable = PageRequest.of(page.intValue() - 1, pageSize.intValue());
        List<Payment> payments = paymentService.findPaymentByRequest(customerFullName, customerPhoneNumber, employeeFullName, pageable);
        Long totalPayment = paymentService.findNumberPaymentByRequest(customerFullName, customerPhoneNumber, employeeFullName, pageable);
        Long totalPages = totalPayment / pageSize;
        if (totalPages * pageSize < totalPayment)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalPayment - 1)
            end = totalPayment - 1;
        Map<String, Object> response = new HashMap<>();
        response.put("totalPages", totalPages);
        List<InvoiceResponseDTO> invoiceResponseDTOs = new ArrayList<>();
        for(Long i = start; i <= end; i++){
            Payment paymentTMP = payments.get(i.intValue());
            InvoiceResponseDTO tmp = new InvoiceResponseDTO(paymentTMP.getId(), paymentTMP.getPaymentDetails(), paymentTMP.getCustomer().getUser(), paymentTMP.getEmployee().getUser(), paymentTMP.getTime());
            invoiceResponseDTOs.add(tmp);
        }
        response.put("invoiceResponseDTOs", invoiceResponseDTOs);
        return ResponseEntity.ok().body(response);
    }

    @GetMapping("/detail/{paymentId}")
    public ResponseEntity<InvoiceResponseDTO> getInvoiceDetail(@PathVariable Long paymentId) {
        Payment payment = paymentService.findById(paymentId);
        List<PaymentDetail> paymentDetails = payment.getPaymentDetails();
        User customer_user = payment.getCustomer().getUser();
        User employee_user = payment.getEmployee().getUser();
        // Long total = payment.getBookFee() + payment.getPunish();
        // String reason = "";
        InvoiceResponseDTO invoiceResponseDTO = new InvoiceResponseDTO(paymentId, paymentDetails, customer_user, employee_user, payment.getTime());
        return ResponseEntity.ok().body(invoiceResponseDTO);
    }
    
    
}