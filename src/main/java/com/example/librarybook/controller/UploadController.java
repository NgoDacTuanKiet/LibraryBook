package com.example.librarybook.controller;

import com.example.librarybook.config.FileStorageProperties;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.*;

@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RestController
@RequestMapping("/api/upload")
public class UploadController {

    private final FileStorageProperties fileStorageProperties;

    public UploadController(FileStorageProperties fileStorageProperties) {
        this.fileStorageProperties = fileStorageProperties;
    }

    @PostMapping
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body("File rỗng!");
            }

            String uploadDir = fileStorageProperties.getUploadDir();
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir, fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            return ResponseEntity.ok("Upload thành công! URL: /uploads/" + fileName);

        } catch (IOException e) {
            return ResponseEntity.internalServerError().body("Lỗi khi upload file: " + e.getMessage());
        }
    }
}
