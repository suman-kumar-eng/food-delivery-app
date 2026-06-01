package com.fooddelivery.app.entity;

import com.fooddelivery.app.enums.OrderStatus;
import jakarta.persistence.*;
import lombok.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Orders {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String orderNumber;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "address_id")
    private Address deliveryAddress;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> orderItems;

    private Double totalAmount;
    private Double discountAmount;
    private Double finalAmount;

    @Temporal(TemporalType.TIMESTAMP)
    private Date orderDate = new Date();

    @Enumerated(EnumType.STRING)
    private OrderStatus status; // PENDING, CONFIRMED, DELIVERED, etc.
    private String paymentMethod; // COD, ONLINE
    private String paymentStatus; // PENDING, COMPLETED, FAILED
    private String paymentTransactionId;
}
