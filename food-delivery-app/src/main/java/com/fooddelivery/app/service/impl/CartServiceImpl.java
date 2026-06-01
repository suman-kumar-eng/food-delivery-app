package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.entity.Cart;
import com.fooddelivery.app.entity.CartItem;
import com.fooddelivery.app.entity.MenuItem;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.exception.ResourceNotFoundException;
import com.fooddelivery.app.repository.CartItemRepository;
import com.fooddelivery.app.repository.CartRepository;
import com.fooddelivery.app.repository.MenuItemRepository;
import com.fooddelivery.app.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.Optional;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private MenuItemRepository menuItemRepository;

    @Override
    public Cart getCartByUser(User user) {
        return cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart cart = new Cart();
                    cart.setUser(user);
                    cart.setItems(new ArrayList<>());
                    return cartRepository.save(cart);
                });
    }

    @Override
    @Transactional
    public void addItemToCart(User user, Long menuItemId, Integer quantity) {
        Cart cart = getCartByUser(user);
        MenuItem item = menuItemRepository.findById(menuItemId)
                .orElseThrow(() -> new ResourceNotFoundException("MenuItem not found"));

        if (!item.isAvailable()) {
            throw new RuntimeException("Item is out of stock");
        }

        Optional<CartItem> existingItem = cart.getItems().stream()
                .filter(ci -> ci.getMenuItem().getId().equals(menuItemId))
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem ci = existingItem.get();
            ci.setQuantity(ci.getQuantity() + quantity);
            cartItemRepository.save(ci);
        } else {
            CartItem ci = new CartItem();
            ci.setCart(cart);
            ci.setMenuItem(item);
            ci.setQuantity(quantity);
            ci.setPrice(item.getOfferPrice() != null ? item.getOfferPrice() : item.getPrice());
            cartItemRepository.save(ci);
        }
    }

    @Override
    public void updateItemQuantity(Long cartItemId, Integer quantity) {
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart item not found"));
        item.setQuantity(quantity);
        cartItemRepository.save(item);
    }

    @Override
    public void removeItemFromCart(Long cartItemId) {
        cartItemRepository.deleteById(cartItemId);
    }

    @Override
    @Transactional
    public void clearCart(User user) {
        Cart cart = getCartByUser(user);
        cartItemRepository.deleteByCart(cart);
    }
}
