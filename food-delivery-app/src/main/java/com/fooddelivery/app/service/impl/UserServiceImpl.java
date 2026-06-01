package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.dto.UserRegistrationDto;
import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.enums.UserRole;
import com.fooddelivery.app.repository.CartRepository;
import com.fooddelivery.app.repository.UserRepository;
import com.fooddelivery.app.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CartRepository cartRepository;

    @Override
    @Transactional
    public User registerUser(UserRegistrationDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setEmail(dto.getEmail());
        // Storing plain text password as 'no security concept' was requested
        user.setPassword(dto.getPassword());
        user.setMobileNumber(dto.getMobileNumber());
        user.setAddress(dto.getAddress());
        user.setRole(dto.getRole());

        User savedUser = userRepository.save(user);

        if (savedUser.getRole() == UserRole.CUSTOMER) {
            Cart cart = new Cart();
            cart.setUser(savedUser);
            cartRepository.save(cart);
        }

        return savedUser;
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User login(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (user.getPassword().equals(password)) {
            return user;
        }
        throw new RuntimeException("Invalid password");
    }

    @Override
    public void updateProfile(User user) {
        userRepository.save(user);
    }
}
