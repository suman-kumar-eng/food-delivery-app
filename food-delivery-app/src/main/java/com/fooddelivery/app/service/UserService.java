package com.fooddelivery.app.service;

import com.fooddelivery.app.dto.UserRegistrationDto;
import com.fooddelivery.app.entity.User;
import java.util.Optional;

public interface UserService {
    User registerUser(UserRegistrationDto registrationDto);
    Optional<User> findByEmail(String email);
    User login(String email, String password);
    void updateProfile(User user);
}
