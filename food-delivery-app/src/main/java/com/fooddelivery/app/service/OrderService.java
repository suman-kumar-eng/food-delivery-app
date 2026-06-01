package com.fooddelivery.app.service;

import com.fooddelivery.app.entity.Address;
import com.fooddelivery.app.entity.Orders;
import com.fooddelivery.app.entity.User;
import com.fooddelivery.app.enums.OrderStatus;
import java.util.List;

public interface OrderService {
    Orders placeOrder(User user, Long addressId, String paymentMethod, String couponCode);
    List<Orders> getOrdersByUser(User user);
    Orders getOrderDetails(Long id);
    List<Orders> getAllOrders();
    void updateOrderStatus(Long id, OrderStatus status);
}
