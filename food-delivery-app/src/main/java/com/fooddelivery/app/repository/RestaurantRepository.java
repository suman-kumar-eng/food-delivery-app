package com.fooddelivery.app.repository;

import com.fooddelivery.app.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    List<Restaurant> findByActiveTrue();
    List<Restaurant> findByNameContainingIgnoreCaseAndActiveTrue(String name);
    List<Restaurant> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseAndActiveTrue(String name, String description);
}
