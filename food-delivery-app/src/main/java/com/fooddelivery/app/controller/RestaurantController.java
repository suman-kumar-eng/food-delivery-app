package com.fooddelivery.app.controller;

import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.enums.FoodType;
import com.fooddelivery.app.service.MenuService;
import com.fooddelivery.app.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private MenuService menuService;

    @GetMapping
    public String listRestaurants(@RequestParam(required = false) String search, Model model) {
        List<Restaurant> restaurants = (search != null && !search.isEmpty()) ?
                restaurantService.searchRestaurants(search) : restaurantService.getAllActiveRestaurants();
        
        if (search != null && !search.isEmpty()) {
            List<MenuItem> matchingItems = menuService.searchMenuItems(search);
            model.addAttribute("matchingItems", matchingItems);
        }
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("searchTerm", search);
        return "restaurant-list";
    }

    @GetMapping("/{id}")
    public String restaurantDetails(@PathVariable Long id, 
                                     @RequestParam(required = false) String foodType, 
                                     Model model) {
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        
        FoodType typeFilter = null;
        if (foodType != null && !foodType.isEmpty()) {
            typeFilter = FoodType.valueOf(foodType);
        }

        List<MenuItem> menuItems = menuService.getMenuItemsByRestaurant(id, typeFilter);
        
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuItems", menuItems);
        model.addAttribute("selectedFoodType", foodType);
        return "restaurant-details";
    }
}
