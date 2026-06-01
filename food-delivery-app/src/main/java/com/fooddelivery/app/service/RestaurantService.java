package com.fooddelivery.app.service;

import com.fooddelivery.app.entity.Restaurant;
import java.util.List;

public interface RestaurantService {
    List<Restaurant> getAllActiveRestaurants();
    List<Restaurant> searchRestaurants(String query);
    Restaurant getRestaurantById(Long id);
    Restaurant saveRestaurant(Restaurant restaurant);
    void deleteRestaurant(Long id);
    void updateRestaurantRating(Long id, Double newRating);
}
