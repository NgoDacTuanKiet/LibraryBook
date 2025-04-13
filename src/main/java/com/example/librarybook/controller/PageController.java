package com.example.librarybook.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/signin")
    public String signinPage() {
        return "forward:/signin.jsp"; // Chuyển hướng đến file trong `webapp/`
    }

    @GetMapping("/signup")
    public String signipPage() {
        return "forward:/signup.jsp";
    }

    @GetMapping("/book_detail")
    public String orderPage() {
        return "forward:/user/book_detail.jsp";
    }

    @GetMapping("/home")
    public String homePage() {
        return "forward:/user/home.jsp";
    }

    @GetMapping("/list_book")
    public String listBookPage() {
        return "forward:/user/list_book.jsp";
    }

    @GetMapping("/love_book")
    public String loveBookPage() {
        return "forward:/user/love_book.jsp";
    }

    @GetMapping("/bill")
    public String billPage() {
        return "forward:/user/bill.jsp";
    }

    @GetMapping("/bill_detail")
    public String billDetailPage() {
        return "forward:/user/bill_detail.jsp";
    }

    @GetMapping("/borrowed")
    public String borrowedPage() {
        return "forward:/user/borrowed.jsp";
    }

    @GetMapping("/borrowing")
    public String borrowingPage() {
        return "forward:/user/borrowing.jsp";
    }

    @GetMapping("/account")
    public String accountPage() {
        return "forward:/user/account.jsp";
    }

    @GetMapping("/book_cart")
    public String bookCartPage() {
        return "forward:/user/book_cart.jsp";
    }

    @GetMapping("/change_password")
    public String changePasswordPage() {
        return "forward:/user/change_password.jsp";
    }

    @GetMapping("/admin/account/list")
    public String adminAccountListPage() {
        return "forward:/admin/account/list.jsp";
    }

    @GetMapping("/admin/account/edit")
    public String adminAccountEditPage() {
        return "forward:/admin/account/edit.jsp";
    }

    @GetMapping("/admin/book/list")
    public String adminBookListPage() {
        return "forward:/admin/book/list.jsp";
    }

    @GetMapping("/admin/book/edit")
    public String adminBookEditPage() {
        return "forward:/admin/book/edit.jsp";
    }

    @GetMapping("/admin/profile/profile")
    public String adminProfilePage() {
        return "forward:/admin/profile/profile.jsp";
    }

    @GetMapping("/admin/profile/change_password")
    public String adminProfileChangePasswordPage() {
        return "forward:/admin/profile/change_password.jsp";
    }

    @GetMapping("/admin/rental/detail")
    public String adminRentalDetail() {
        return "forward:/admin/rental/detail.jsp";
    }

    @GetMapping("/admin/rental/list")
    public String adminRentalList() {
        return "forward:/admin/rental/list.jsp";
    }

    @GetMapping("/admin/rental/payment")
    public String adminRentalPayment() {
        return "forward:/admin/rental/payment.jsp";
    }

    @GetMapping("/admin/category/edit")
    public String adminCategoryEditPage() {
        return "forward:/admin/category/edit.jsp";
    }

    @GetMapping("/admin/employee/edit")
    public String adminEmployeeEditPage() {
        return "forward:/admin/employee/edit.jsp";
    }

    @GetMapping("/admin/employee/list")
    public String adminEmplyeePage() {
        return "forward:/admin/employee/list.jsp";
    }
}