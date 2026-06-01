package com.fooddelivery.app.config;

import com.fooddelivery.app.entity.Category;
import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.enums.UserRole;
import com.fooddelivery.app.repository.CategoryRepository;
import com.fooddelivery.app.repository.RestaurantRepository;
import com.fooddelivery.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Override
    public void run(String... args) throws Exception {
        // Create Default Admin if none exists
        if (!userRepository.existsByEmail("admin@zomato.com")) {
            User admin = new User();
            admin.setFirstName("System");
            admin.setLastName("Admin");
            admin.setEmail("admin@zomato.com");
            admin.setPassword("admin"); // Storing plain text as requested
            admin.setMobileNumber("9876543210");
            admin.setRole(UserRole.ADMIN);
            userRepository.save(admin);
            System.out.println(">>> Created Default Admin: admin@zomato.com / admin");
        }

        // Create some sample categories if none exist
        if (categoryRepository.count() == 0) {
            String[] categories = {"Biryani", "Pizza", "Desserts", "North Indian"};
            for (String catName : categories) {
                Category cat = new Category();
                cat.setName(catName);
                categoryRepository.save(cat);
            }
            System.out.println(">>> Initialized default categories.");
        }

        // Create a sample restaurant if none exists
        if (restaurantRepository.count() == 0) {
            Restaurant res = new Restaurant();
            res.setName("Zomato Kitchen");
            res.setDescription("The best of Hyderabad delivered to you.");
            res.setImageUrl("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800");
            res.setRating(4.5);
            res.setAddress("Cyber Towers, HITEC City, Hyderabad");
            res.setPhoneNumber("9000000001");
            res.setActive(true);
            restaurantRepository.save(res);
            System.out.println(">>> Initialized sample restaurant.");
        }
    }
}
