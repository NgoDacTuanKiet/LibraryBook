package com.example.librarybook.controller;

import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.librarybook.model.Book;
import com.example.librarybook.model.Category;
import com.example.librarybook.model.Customer;
import com.example.librarybook.model.User;
import com.example.librarybook.services.BookService;
import com.example.librarybook.services.CategoryService;
import com.example.librarybook.services.CustomerService;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@RestController
@RequestMapping("/api/book")
@CrossOrigin(origins = "*")
public class BookController {
    @Autowired
    private BookService bookService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private CustomerService customerService;
    
    @GetMapping("/search")
    public ResponseEntity<List<Book>> searchBooks(
            @RequestParam(required = false) String bookName,
            @RequestParam(required = false) String publisher,
            @RequestParam(required = false) String author,
            @RequestParam(required = false) String yearOfpublication,
            @RequestParam(required = false) List<Long> categories) {

        List<Book> books = bookService.searchBooks(bookName, publisher, author, yearOfpublication, categories, 1);
        return ResponseEntity.ok(books);
    }

    @PostMapping(value = "/save", consumes = "multipart/form-data")
    public String saveBook(@RequestParam Map<String, Object> formData,
                        @RequestParam List<Long> categories,
                        @RequestParam("image") MultipartFile imageFile) {
        try {
            Book newBook = new Book();
            newBook.setBookName((String) formData.get("name"));
            newBook.setAuthor((String) formData.get("author"));
            newBook.setPublisher((String) formData.getOrDefault("publisher", null));
            newBook.setYearOfpublication((String) formData.getOrDefault("yearOfpublication", null));
            newBook.setQuantity(Long.parseLong(formData.get("quantity").toString()));
            newBook.setAvailableQuantity(newBook.getQuantity());
            newBook.setDescribe((String) formData.get("describe"));
            newBook.setStatus(1);

            // Xử lý lưu ảnh (nếu có)
            if (!imageFile.isEmpty()) {
                String fileName = imageFile.getOriginalFilename();
                String uploadDir = "src/main/resources/static/uploads/book/";
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Files.copy(imageFile.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
                newBook.setImageUrl("/uploads/book/" + fileName);
            }

            // Thêm thể loại
            List<Category> categoryList = new ArrayList<>();
            for (Long id : categories) {
                Category tmp = categoryService.getCategoryById(id).orElse(null);
                if (tmp != null) {
                    categoryList.add(tmp); // Gán danh sách thể loại cho sách
                    if (!tmp.getBooksOfCategory().stream().anyMatch(book -> book.getId().equals(newBook.getId()))) {
                        tmp.getBooksOfCategory().add(newBook); // Chỉ thêm nếu chưa tồn tại
                    }
                }
            }
            newBook.setCategoriesOfBook(categoryList);

            // Lưu sách vào database
            bookService.saveBook(newBook);
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/book/list?error";
        }
        return "redirect:/admin/book/list?success";
    }

    @GetMapping("/{bookId}")
    public ResponseEntity<Book> getBookById(@PathVariable Long bookId) {
        Book book = bookService.getBookByID(bookId);
        return ResponseEntity.ok(book);
    }

    @PostMapping("/love/{bookId}")
    public ResponseEntity<String> loveBook(@PathVariable Long bookId, HttpSession session) {
        User user = ((User) session.getAttribute("user"));

        Long userId = user.getId();
        Customer customer = customerService.getCustomerByUserId(userId);
        Book book = bookService.getBookByID(bookId);

        List<Customer> customers = book.getLikedByCustomers();
        List<Book> books = customer.getFavoriteBooks();

        customers.add(customer);
        books.add(book);
        bookService.saveBook(book);
        return ResponseEntity.ok().body("{\"message\": \"Đã thêm vào danh mục yêu thích\"}");
    }
    
    @PostMapping(value = "/update/{bookId}", consumes = "multipart/form-data")
    public String updateBook(@PathVariable Long bookId,
                            @RequestParam Map<String, Object> formData,
                            @RequestParam List<Long> categories,
                            @RequestParam("image") MultipartFile imageFile,
                            @RequestParam(value = "currentImageUrl", required = false) String currentImageUrl) throws Exception {
        Book book = bookService.getBookByID(bookId);
        book.setBookName((String) formData.get("name"));
        book.setAuthor((String) formData.get("author"));
        book.setPublisher((String) formData.getOrDefault("publisher", null));
        book.setYearOfpublication((String) formData.getOrDefault("yearOfpublication", null));
        book.setQuantity(Long.parseLong(formData.get("quantity").toString()) + book.getQuantity());
        book.setDescribe((String) formData.get("describe"));

        if (!imageFile.isEmpty()) {
            String fileName = imageFile.getOriginalFilename();
            String uploadDir = "src/main/resources/static/uploads/book/";
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            Files.copy(imageFile.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            book.setImageUrl("/uploads/book/" + fileName);
        } else if (currentImageUrl != null && !currentImageUrl.isEmpty()) {
            book.setImageUrl(currentImageUrl); // Giữ lại ảnh cũ nếu không upload ảnh mới
        }

        List<Category> categoryList = new ArrayList<>();
            for (Long id : categories) {
                Category tmp = categoryService.getCategoryById(id).orElse(null);
                if (tmp != null) {
                    categoryList.add(tmp); // Gán danh sách thể loại cho sách
                    if (!tmp.getBooksOfCategory().stream().anyMatch(bookTmp -> bookTmp.getId().equals(book.getId()))) {
                        tmp.getBooksOfCategory().add(book); // Chỉ thêm nếu chưa tồn tại
                    }
                }
            }
        book.setCategoriesOfBook(categoryList);
        bookService.saveBook(book);
        return "";
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable Long id) {
        Book book = bookService.getBookByID(id);
        book.setStatus(0);
        bookService.saveBook(book);
        return ResponseEntity.noContent().build();
    }
}
