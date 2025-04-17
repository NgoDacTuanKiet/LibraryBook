package com.example.librarybook.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.librarybook.model.Book;
import com.example.librarybook.model.Cart;
import com.example.librarybook.model.CartDetail;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.repository.CartRepository;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.CartDetailService;
import com.example.librarybook.services.CartService;
import com.example.librarybook.services.CustomerService;

import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/cart")
public class CartController {
    @Autowired
    private CartService cartService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private BookService bookService;

    @Autowired
    private CartDetailService cartDetailService;

    @Autowired
    private CartRepository cartRepository;

    @PostMapping("/add/{bookId}")
    public ResponseEntity<Map<String, String>> addBookToCart(@PathVariable Long bookId, HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        Cart cart = cartService.getCartByCustomerId(customer.getId());
        CartDetail cartDetail = new CartDetail();

        Book book = bookService.getBookByID(bookId);
        if(book.getAvailableQuantity() < 1){
            Map<String, String> response = new HashMap<>();
            response.put("message", "Sách đã hết, vui lòng quay lại sau!");
            return ResponseEntity.badRequest().body(response);
        }
        cartDetail.setBook(book);
        cartDetail.setQuantity(1L);
        cartDetail.setCart(cart);
        for(CartDetail i: cart.getCartDetails()){
            if(i.getBook().getId() == bookId){
                Map<String, String> response = new HashMap<>();
                response.put("message", "Sách đã có trong giỏ hàng!");
                return ResponseEntity.badRequest().body(response);
            }
        }
        cart.getCartDetails().add(cartDetail);
        
        cartRepository.save(cart);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Thêm sách vào giỏ thanh công!");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/list")
    public ResponseEntity<List<CartDetail>> getCartDetails(HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        if (tmp == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        Cart cart = cartService.getCartByCustomerId(customer.getId());
        
        List<CartDetail> cartDetails = cart.getCartDetails();

        return ResponseEntity.ok(cartDetails);
    }

    @PostMapping("/remove/{cartDetailId}")
    public String removeCartDetail(@PathVariable Long cartDetailId, HttpSession session) {
        User tmp = (User) session.getAttribute("user");
        Customer customer = customerService.getCustomerByUserId(tmp.getId());
        Cart cart = cartService.getCartByCustomerId(customer.getId());
        cartService.removeCartDetailById(cart, cartDetailId);
        return "";
    }

    @PostMapping("/update/{cartDetailId}")
    public ResponseEntity<Map<String, String>> updateCartDetail(@PathVariable Long cartDetailId, @RequestBody Map<String, Object> request) {
        String tmp = (String) request.get("newQuantity");
        Long newQuantity = Long.parseLong(tmp);

        CartDetail cartDetail = cartDetailService.findById(cartDetailId);
        Book book = cartDetail.getBook();
        if(book.getAvailableQuantity() < newQuantity){
            Map<String, String> response = new HashMap<>();
            response.put("message", "Số lượng sách còn lại không đủ");
            return ResponseEntity.badRequest().body(response);
        }
        cartDetailService.updateCartDetailById(cartDetailId, newQuantity);
        return ResponseEntity.ok(null);
    }
    
}