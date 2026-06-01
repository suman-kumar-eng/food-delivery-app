package com.fooddelivery.app.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.Date;

@Entity
@Table(name = "payment_transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "order_id")
    private Orders order;

    private String transactionId;
    private String paymentStatus;
    private String paymentMethod;
    private Double amount;

    @Temporal(TemporalType.TIMESTAMP)
    private Date transactionDate = new Date();
}
