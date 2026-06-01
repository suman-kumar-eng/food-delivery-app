package com.fooddelivery.app.controller;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.Orders;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.repository.AddressRepository;
import com.fooddelivery.app.service.CartService;
import com.fooddelivery.app.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private CartService cartService;

    @Autowired
    private AddressRepository addressRepository;

    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        Cart cart = cartService.getCartByUser(user);
        if (cart.getItems().isEmpty()) return "redirect:/cart?empty=true";

        model.addAttribute("cart", cart);
        model.addAttribute("addresses", addressRepository.findByUser(user));
        
        // Add an empty Address object for the address creation modal
        model.addAttribute("newAddress", new com.fooddelivery.app.entity.Address());
        
        Double total = cart.getItems().stream()
                .mapToDouble(i -> i.getPrice() * i.getQuantity())
                .sum();
        model.addAttribute("total", total);
        
        return "checkout";
    }

    @PostMapping("/checkout/add-address")
    public String addAddress(@ModelAttribute com.fooddelivery.app.entity.Address address, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        
        address.setUser(user);
        addressRepository.save(address);
        
        return "redirect:/orders/checkout";
    }

    @PostMapping("/place")
    public String placeOrder(@RequestParam Long addressId, 
                             @RequestParam String paymentMethod, 
                             @RequestParam(required = false) String couponCode, 
                             HttpSession session, 
                             org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        try {
            Orders order = orderService.placeOrder(user, addressId, paymentMethod, couponCode);
            return "redirect:/orders/" + order.getId() + "?placed=true";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/orders/checkout";
        }
    }

    @GetMapping
    public String orderHistory(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        List<Orders> orders = orderService.getOrdersByUser(user);
        model.addAttribute("orders", orders);
        return "order-history";
    }

    @GetMapping("/{id}")
    public String orderDetails(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        Orders order = orderService.getOrderDetails(id);
        // Basic security check: user can only see their own orders unless admin
        if (!order.getUser().getId().equals(user.getId()) && !user.getRole().name().equals("ADMIN")) {
            return "redirect:/access-denied";
        }
        model.addAttribute("order", order);
        return "order-details";
    }
}
