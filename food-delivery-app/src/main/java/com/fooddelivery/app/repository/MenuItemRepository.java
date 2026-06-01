package com.fooddelivery.app.repository;

import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.enums.FoodType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
    List<MenuItem> findByRestaurantAndActiveTrue(Restaurant restaurant);
    List<MenuItem> findByRestaurantAndFoodTypeAndActiveTrue(Restaurant restaurant, FoodType foodType);
    List<MenuItem> findByCategoryIdAndActiveTrue(Long categoryId);
    List<MenuItem> findByNameContainingIgnoreCaseAndActiveTrue(String name);
    List<MenuItem> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseOrCategory_NameContainingIgnoreCaseAndActiveTrue(String name, String description, String categoryName);
}
