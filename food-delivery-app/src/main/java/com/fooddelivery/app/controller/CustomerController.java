package com.fooddelivery.app.controller;

import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "customer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User updatedUser, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("loggedInUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        // Update fields
        currentUser.setFirstName(updatedUser.getFirstName());
        currentUser.setLastName(updatedUser.getLastName());
        currentUser.setMobileNumber(updatedUser.getMobileNumber());
        currentUser.setAddress(updatedUser.getAddress());
        
        userService.updateProfile(currentUser);
        session.setAttribute("loggedInUser", currentUser);
        model.addAttribute("success", "Profile updated successfully!");
        model.addAttribute("user", currentUser);
        
        return "customer/profile";
    }
}
