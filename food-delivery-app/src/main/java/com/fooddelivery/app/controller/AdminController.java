package com.fooddelivery.app.controller;

import com.fooddelivery.app.entity.*;
import com.fooddelivery.app.enums.FoodType;
import com.fooddelivery.app.enums.OrderStatus;
import com.fooddelivery.app.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private MenuService menuService;
    
    @Autowired
    private OrderService orderService;

    @Autowired
    private FileService fileService;

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        return user != null && user.getRole().name().equals("ADMIN");
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        
        model.addAttribute("restaurantCount", restaurantService.getAllActiveRestaurants().size());
        model.addAttribute("orderCount", orderService.getAllOrders().size());
        model.addAttribute("categoryCount", categoryService.getAllCategories().size());
        model.addAttribute("menuItemCount", menuService.getAllMenuItems().size());
        
        return "admin/admin-dashboard";
    }

    // ─── Restaurant Management ────────────────────────────────────────────────

    @GetMapping("/restaurants")
    public String manageRestaurants(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("restaurants", restaurantService.getAllActiveRestaurants());
        return "admin/restaurant-list"; 
    }

    @GetMapping("/restaurants/add")
    public String showAddRestaurant(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("restaurant", new Restaurant());
        return "admin/restaurant-form";
    }

    @PostMapping("/restaurants/save")
    public String saveRestaurant(@ModelAttribute Restaurant restaurant, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        restaurantService.saveRestaurant(restaurant);
        return "redirect:/admin/restaurants";
    }

    @GetMapping("/restaurants/edit/{id}")
    public String showEditRestaurant(@PathVariable Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("restaurant", restaurantService.getRestaurantById(id));
        return "admin/restaurant-form";
    }

    @PostMapping("/restaurants/delete/{id}")
    public String deleteRestaurant(@PathVariable Long id, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        restaurantService.deleteRestaurant(id);
        return "redirect:/admin/restaurants";
    }

    // ─── Category Management ──────────────────────────────────────────────────

    @GetMapping("/categories")
    public String manageCategories(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/category-list";
    }

    @PostMapping("/categories/save")
    public String saveCategory(@RequestParam String name, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        Category category = new Category();
        category.setName(name);
        categoryService.saveCategory(category);
        return "redirect:/admin/categories";
    }

    // ─── Menu Item Management ─────────────────────────────────────────────────

    @GetMapping("/menu-items")
    public String manageMenuItems(HttpSession session, Model model,
                                   @RequestParam(required = false) Long restaurantId) {
        if (!isAdmin(session)) return "redirect:/login";
        List<Restaurant> restaurants = restaurantService.getAllActiveRestaurants();
        model.addAttribute("restaurants", restaurants);

        if (restaurantId != null) {
            model.addAttribute("menuItems", menuService.getAllMenuItemsByRestaurant(restaurantId));
            model.addAttribute("selectedRestaurantId", restaurantId);
        } else {
            model.addAttribute("menuItems", menuService.getAllMenuItems());
        }
        return "admin/menu-item-list";
    }

    @GetMapping("/menu-items/add")
    public String showAddMenuItem(HttpSession session, Model model,
                                   @RequestParam(required = false) Long restaurantId) {
        if (!isAdmin(session)) return "redirect:/login";
        MenuItem item = new MenuItem();
        model.addAttribute("menuItem", item);
        model.addAttribute("restaurants", restaurantService.getAllActiveRestaurants());
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("foodTypes", FoodType.values());
        model.addAttribute("preselectedRestaurantId", restaurantId);
        return "admin/menu-item-form";
    }

    @GetMapping("/menu-items/edit/{id}")
    public String showEditMenuItem(@PathVariable Long id, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        MenuItem item = menuService.getMenuItemById(id);
        model.addAttribute("menuItem", item);
        model.addAttribute("restaurants", restaurantService.getAllActiveRestaurants());
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("foodTypes", FoodType.values());
        return "admin/menu-item-form";
    }

    @PostMapping("/menu-items/save")
    public String saveMenuItem(@RequestParam String name,
                                @RequestParam String description,
                                @RequestParam Double price,
                                @RequestParam(required = false) Double offerPrice,
                                @RequestParam(required = false) String imageUrl,
                                @RequestParam(required = false) org.springframework.web.multipart.MultipartFile imageFile,
                                @RequestParam FoodType foodType,
                                @RequestParam Long restaurantId,
                                @RequestParam Long categoryId,
                                @RequestParam(required = false) Long menuItemId,
                                @RequestParam(defaultValue = "false") boolean available,
                                HttpSession session) throws java.io.IOException {
        if (!isAdmin(session)) return "redirect:/login";

        MenuItem item = (menuItemId != null) ? menuService.getMenuItemById(menuItemId) : new MenuItem();
        item.setName(name);
        item.setDescription(description);
        item.setPrice(price);
        item.setOfferPrice(offerPrice);
        
        // Handle image: priority to uploaded file, then URL
        if (imageFile != null && !imageFile.isEmpty()) {
            String uploadedPath = fileService.uploadFile(imageFile, "menu");
            item.setImageUrl(uploadedPath);
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            item.setImageUrl(imageUrl);
        }
        
        item.setFoodType(foodType);
        item.setAvailable(available);
        item.setActive(true);

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        item.setRestaurant(restaurant);

        Category category = categoryService.getCategoryById(categoryId);
        item.setCategory(category);

        menuService.saveMenuItem(item);
        return "redirect:/admin/menu-items?restaurantId=" + restaurantId;
    }

    @PostMapping("/menu-items/delete/{id}")
    public String deleteMenuItem(@PathVariable Long id, HttpSession session,
                                  @RequestParam(required = false) Long restaurantId) {
        if (!isAdmin(session)) return "redirect:/login";
        menuService.deleteMenuItem(id);
        return (restaurantId != null)
               ? "redirect:/admin/menu-items?restaurantId=" + restaurantId
               : "redirect:/admin/menu-items";
    }

    // ─── Order Management ────────────────────────────────────────────────────

    @GetMapping("/orders")
    public String manageOrders(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("orders", orderService.getAllOrders());
        return "admin/order-list";
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam Long orderId, @RequestParam OrderStatus status, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        orderService.updateOrderStatus(orderId, status);
        return "redirect:/admin/orders";
    }

    @PostMapping("/menu-items/toggle-availability/{id}")
    public String toggleMenuItemAvailability(@PathVariable Long id, HttpSession session,
                                              @RequestParam(required = false) Long restaurantId) {
        if (!isAdmin(session)) return "redirect:/login";
        MenuItem item = menuService.getMenuItemById(id);
        item.setAvailable(!item.isAvailable());
        menuService.saveMenuItem(item);
        return (restaurantId != null)
               ? "redirect:/admin/menu-items?restaurantId=" + restaurantId
               : "redirect:/admin/menu-items";
    }
}
