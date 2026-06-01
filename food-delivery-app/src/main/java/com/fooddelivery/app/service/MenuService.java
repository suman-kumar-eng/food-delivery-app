package com.fooddelivery.app.service;

import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.enums.FoodType;
import java.util.List;

public interface MenuService {
    List<MenuItem> getMenuItemsByRestaurant(Long restaurantId, FoodType foodType);
    List<MenuItem> getAllMenuItems();
    List<MenuItem> getAllMenuItemsByRestaurant(Long restaurantId);
    MenuItem getMenuItemById(Long id);
    MenuItem saveMenuItem(MenuItem menuItem);
    void deleteMenuItem(Long id);
    List<MenuItem> getMenuItemsByCategory(Long categoryId);
    List<MenuItem> searchMenuItems(String query);
}
