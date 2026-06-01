package com.fooddelivery.app.repository;

import com.fooddelivery.app.entity.Orders;
import com.fooddelivery.app.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface OrdersRepository extends JpaRepository<Orders, Long> {
    List<Orders> findByUserOrderByOrderDateDesc(User user);
    Optional<Orders> findByOrderNumber(String orderNumber);
}
