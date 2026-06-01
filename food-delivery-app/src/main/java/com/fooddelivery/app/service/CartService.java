package com.fooddelivery.app.service;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.CartItem;
import com.fooddelivery.app.entity.User;

public interface CartService {
    Cart getCartByUser(User user);
    void addItemToCart(User user, Long menuItemId, Integer quantity);
    void updateItemQuantity(Long cartItemId, Integer quantity);
    void removeItemFromCart(Long cartItemId);
    void clearCart(User user);
}
