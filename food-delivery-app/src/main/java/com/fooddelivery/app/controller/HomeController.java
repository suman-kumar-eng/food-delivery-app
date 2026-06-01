package com.fooddelivery.app.controller;

import com.fooddelivery.app.dto.UserRegistrationDto;
import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.entity.Restaurant;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.service.MenuService;
import com.fooddelivery.app.service.RestaurantService;
import com.fooddelivery.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private MenuService menuService;

    @Autowired
    private UserService userService;

    @GetMapping({"/", "/home"})
    public String home(Model model, HttpSession session, @RequestParam(required = false) String search) {
        List<Restaurant> restaurants = (search != null && !search.isEmpty()) ?
                restaurantService.searchRestaurants(search) : restaurantService.getAllActiveRestaurants();
        model.addAttribute("restaurants", restaurants);

        // Get featured items — filter by search if present
        List<MenuItem> featuredItems;
        if (search != null && !search.isEmpty()) {
            featuredItems = menuService.searchMenuItems(search).stream()
                    .limit(20)
                    .collect(Collectors.toList());
        } else {
            featuredItems = menuService.getAllMenuItems().stream()
                    .limit(8)
                    .collect(Collectors.toList());
        }
        model.addAttribute("featuredItems", featuredItems);
        model.addAttribute("searchTerm", search);

        return "home";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email, @RequestParam String password, 
                              HttpSession session, Model model) {
        try {
            User user = userService.login(email, password);
            session.setAttribute("loggedInUser", user);
            
            if (user.getRole().name().equals("ADMIN")) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/";
        } catch (Exception e) {
            model.addAttribute("error", "Invalid email or password");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout=true";
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new UserRegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@Valid @ModelAttribute("user") UserRegistrationDto dto, 
                               BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "register";
        }
        try {
            userService.registerUser(dto);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
        return "redirect:/login?registered=true";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }
}
