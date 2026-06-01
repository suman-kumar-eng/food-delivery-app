package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.exception.ResourceNotFoundException;
import com.fooddelivery.app.repository.RestaurantRepository;
import com.fooddelivery.app.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class RestaurantServiceImpl implements RestaurantService {

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Override
    public List<Restaurant> getAllActiveRestaurants() {
        return restaurantRepository.findByActiveTrue();
    }

    @Override
    public List<Restaurant> searchRestaurants(String query) {
        return restaurantRepository.findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseAndActiveTrue(query, query);
    }

    @Override
    public Restaurant getRestaurantById(Long id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found with id: " + id));
    }

    @Override
    public Restaurant saveRestaurant(Restaurant restaurant) {
        return restaurantRepository.save(restaurant);
    }

    @Override
    public void deleteRestaurant(Long id) {
        Restaurant restaurant = getRestaurantById(id);
        restaurant.setActive(false);
        restaurantRepository.save(restaurant);
    }

    @Override
    public void updateRestaurantRating(Long id, Double newRating) {
        Restaurant restaurant = getRestaurantById(id);
        restaurant.setRating(newRating);
        restaurantRepository.save(restaurant);
    }
}
