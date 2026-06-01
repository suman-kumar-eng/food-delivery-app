package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.enums.FoodType;
import com.fooddelivery.app.exception.ResourceNotFoundException;
import com.fooddelivery.app.repository.MenuItemRepository;
import com.fooddelivery.app.repository.RestaurantRepository;
import com.fooddelivery.app.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {

    @Autowired
    private MenuItemRepository menuItemRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Override
    public List<MenuItem> getMenuItemsByRestaurant(Long restaurantId, FoodType foodType) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found"));
        
        if (foodType != null) {
            return menuItemRepository.findByRestaurantAndFoodTypeAndActiveTrue(restaurant, foodType);
        }
        return menuItemRepository.findByRestaurantAndActiveTrue(restaurant);
    }

    @Override
    public MenuItem getMenuItemById(Long id) {
        return menuItemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Menu item not found with id: " + id));
    }

    @Override
    public MenuItem saveMenuItem(MenuItem menuItem) {
        return menuItemRepository.save(menuItem);
    }

    @Override
    public void deleteMenuItem(Long id) {
        MenuItem item = getMenuItemById(id);
        item.setActive(false);
        menuItemRepository.save(item);
    }

    @Override
    public List<MenuItem> getMenuItemsByCategory(Long categoryId) {
        return menuItemRepository.findByCategoryIdAndActiveTrue(categoryId);
    }

    @Override
    public List<MenuItem> getAllMenuItems() {
        return menuItemRepository.findAll().stream()
                .filter(MenuItem::isActive)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public List<MenuItem> getAllMenuItemsByRestaurant(Long restaurantId) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found with id: " + restaurantId));
        return menuItemRepository.findByRestaurantAndActiveTrue(restaurant);
    }

    @Override
    public List<MenuItem> searchMenuItems(String query) {
        return menuItemRepository.findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseOrCategory_NameContainingIgnoreCaseAndActiveTrue(query, query, query);
    }
}
