package com.example.librarybook.controller;

import com.example.librarybook.model.Category;
import com.example.librarybook.services.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/categories")
@CrossOrigin(origins = "*")
public class CategoryController {
    @Autowired
    private CategoryService categoryService;

    // Lấy danh sách thể loại
    @GetMapping
    public List<Category> getAllCategories() {
        return categoryService.getAllCategories();
    }

    // Lấy thể loại theo ID
    @GetMapping("/{id}")
    public ResponseEntity<Category> getCategoryById(@PathVariable Long id) {
        Optional<Category> category = categoryService.getCategoryById(id);
        return category.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Thêm thể loại
    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> saveCategory(@RequestBody Category category) {
        Map<String, String> response = new HashMap<>();
        if(categoryService.findCategoryByName(category.getName()) != null){
            response.put("message", "Thể loại đã tồn tại!");
            return ResponseEntity.badRequest().body(response);
        }
        categoryService.saveCategory(category);
        response.put("message", "Thêm thể loại thành công");
        return ResponseEntity.ok().body(response);
    }

    // Xóa thể loại
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.noContent().build();
    }

}
