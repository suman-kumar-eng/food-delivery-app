package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.service.FileService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {

    private final String uploadDir = "src/main/resources/static/images/menu/";

    @Override
    public String uploadFile(MultipartFile file, String directory) throws IOException {
        if (file.isEmpty()) {
            return null;
        }

        String fileName = UUID.randomUUID().toString() + "_" + StringUtils.cleanPath(file.getOriginalFilename());
        Path path = Paths.get(uploadDir + fileName);

        if (!Files.exists(path.getParent())) {
            Files.createDirectories(path.getParent());
        }

        Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);

        // Return the relative URL for the browser
        return "/static/images/menu/" + fileName;
    }
}
