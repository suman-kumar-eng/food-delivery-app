package com.fooddelivery.app.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.Date;

@Entity
@Table(name = "coupons")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String code;

    private String description;
    private Double discountPercent;
    private Double maxDiscountAmount;
    private Double minOrderAmount;

    @Temporal(TemporalType.DATE)
    private Date expiryDate;

    private boolean active = true;
}
