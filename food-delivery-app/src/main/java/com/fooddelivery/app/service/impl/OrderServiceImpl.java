package com.fooddelivery.app.service.impl;

import com.fooddelivery.app.entity.*;
import com.fooddelivery.app.enums.OrderStatus;
import com.fooddelivery.app.exception.ResourceNotFoundException;
import com.fooddelivery.app.repository.*;
import com.fooddelivery.app.service.CartService;
import com.fooddelivery.app.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    private CartService cartService;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private PaymentTransactionRepository paymentTransactionRepository;

    @Override
    @Transactional
    public Orders placeOrder(User user, Long addressId, String paymentMethod, String couponCode) {
        Cart cart = cartService.getCartByUser(user);
        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Address address = addressRepository.findById(addressId)
                .orElseThrow(() -> new ResourceNotFoundException("Address not found"));

        Orders order = new Orders();
        order.setOrderNumber("ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setUser(user);
        order.setDeliveryAddress(address);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus(paymentMethod.equalsIgnoreCase("COD") ? "PENDING" : "COMPLETED");
        order.setStatus(OrderStatus.PENDING);

        Double totalAmount = cart.getItems().stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
        
        Double discountAmount = 0.0;
        if (couponCode != null && !couponCode.isEmpty()) {
            Coupon coupon = couponRepository.findByCodeAndActiveTrue(couponCode).orElse(null);
            if (coupon != null && totalAmount >= coupon.getMinOrderAmount()) {
                discountAmount = (totalAmount * coupon.getDiscountPercent()) / 100;
                if (discountAmount > coupon.getMaxDiscountAmount()) {
                    discountAmount = coupon.getMaxDiscountAmount();
                }
            }
        }

        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discountAmount);
        order.setFinalAmount(totalAmount - discountAmount);

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setMenuItem(ci.getMenuItem());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getPrice());
            orderItems.add(oi);
        }
        order.setOrderItems(orderItems);

        String txnId = null;
        if (paymentMethod.equalsIgnoreCase("ONLINE")) {
            txnId = "TXN-" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
            order.setPaymentTransactionId(txnId);
        }
        
        Orders savedOrder = ordersRepository.save(order);
        
        // Save Payment Transaction record
        if (txnId != null) {
            PaymentTransaction transaction = new PaymentTransaction();
            transaction.setOrder(savedOrder);
            transaction.setAmount(savedOrder.getFinalAmount());
            transaction.setPaymentMethod(paymentMethod);
            transaction.setPaymentStatus(savedOrder.getPaymentStatus());
            transaction.setTransactionId(txnId);
            paymentTransactionRepository.save(transaction);
        }

        cartService.clearCart(user);
        return savedOrder;
    }

    @Override
    public List<Orders> getOrdersByUser(User user) {
        return ordersRepository.findByUserOrderByOrderDateDesc(user);
    }

    @Override
    public Orders getOrderDetails(Long id) {
        return ordersRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Order not found"));
    }

    @Override
    public List<Orders> getAllOrders() {
        return ordersRepository.findAll();
    }

    @Override
    public void updateOrderStatus(Long id, OrderStatus status) {
        Orders order = getOrderDetails(id);
        order.setStatus(status);
        ordersRepository.save(order);
    }
}
