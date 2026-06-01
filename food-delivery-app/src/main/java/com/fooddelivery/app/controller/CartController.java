package com.fooddelivery.app.controller;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }
        Cart cart = cartService.getCartByUser(user);
        model.addAttribute("cart", cart);
        
        Double total = cart.getItems().stream()
                .mapToDouble(i -> i.getPrice() * i.getQuantity())
                .sum();
        model.addAttribute("total", total);
        
        return "cart";
    }

    @PostMapping("/add")
    @ResponseBody
    public String addToCart(@RequestParam Long menuItemId, 
                            @RequestParam(defaultValue = "1") Integer quantity, 
                            HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "REDIRECT_LOGIN";
        }
        try {
            cartService.addItemToCart(user, menuItemId, quantity);
            return "SUCCESS";
        } catch (RuntimeException e) {
            return "OUT_OF_STOCK";
        }
    }

    @GetMapping("/summary")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartSummary(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        Map<String, Object> summary = new HashMap<>();
        
        if (user == null) {
            summary.put("count", 0);
            summary.put("total", 0.0);
            return ResponseEntity.ok(summary);
        }
        
        Cart cart = cartService.getCartByUser(user);
        int count = cart.getItems().stream().mapToInt(i -> i.getQuantity()).sum();
        double total = cart.getItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
        
        summary.put("count", count);
        summary.put("total", total);
        return ResponseEntity.ok(summary);
    }

    @PostMapping("/update")
    public String updateQuantity(@RequestParam Long cartItemId, 
                                 @RequestParam Integer quantity) {
        cartService.updateItemQuantity(cartItemId, quantity);
        return "redirect:/cart";
    }

    @GetMapping("/remove/{id}")
    public String removeItem(@PathVariable Long id) {
        cartService.removeItemFromCart(id);
        return "redirect:/cart";
    }
}
