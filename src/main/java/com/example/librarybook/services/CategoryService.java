package com.example.librarybook.services;

import com.example.librarybook.model.Category;
import com.example.librarybook.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;

    // Lấy tất cả thể loại
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    // Lấy thể loại theo ID
    public Optional<Category> getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }

    // Thêm / sửa thể loại mới
    public Category saveCategory(Category category) {
        return categoryRepository.save(category);
    }

    public Category findCategoryByName(String name){
        return categoryRepository.findByName(name);
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }
}
