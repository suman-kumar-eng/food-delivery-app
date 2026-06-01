package com.fooddelivery.app.repository;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    @Modifying
    @Transactional
    @Query("DELETE FROM CartItem ci WHERE ci.cart = :cart")
    void deleteByCart(Cart cart);
}
