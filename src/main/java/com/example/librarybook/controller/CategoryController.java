package com.example.librarybook.controller;

import com.example.librarybook.model.Category;
import com.example.librarybook.services.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
    public Map<String, Object> getAllCategories(@RequestParam Long page,
                                           @RequestParam Long pageSize) {
        Pageable pageable = PageRequest.of(page.intValue() - 1, pageSize.intValue());
        List<Category> categories = categoryService.getAllCategoriesPageable(pageable);
        Long totalCategory = categoryService.getNumberOfCategory();
        Long totalPages = totalCategory / pageSize;
        if (totalPages * pageSize < totalCategory)
            totalPages += 1;
        Long start = (page-1) * pageSize;
        Long end = start + pageSize - 1;
        if (end > totalCategory - 1)
            end = totalCategory - 1;
        Map<String, Object> response = new HashMap<>();
        response.put("categories", categories);
        response.put("totalPages", totalPages);
        return response;
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
