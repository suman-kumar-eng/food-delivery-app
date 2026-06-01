package com.fooddelivery.app.repository;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser(User user);
}
