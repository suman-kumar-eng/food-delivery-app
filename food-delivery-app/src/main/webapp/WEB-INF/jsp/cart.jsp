<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - Zomato Hyderabad</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .cart-wrapper { max-width: 900px; margin: 40px auto; }
        .cart-card { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 1px 10px rgba(0,0,0,0.05); }
        .res-info-mini { display: flex; align-items: center; gap: 15px; margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px dashed var(--zomato-border); }
        .item-list-row { display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px; }
        .bill-summary { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 1px 10px rgba(0,0,0,0.05); }
        .qty-control-box { border: 1px solid var(--zomato-red); background: #FFF1F2; border-radius: 6px; display: flex; align-items: center; overflow: hidden; }
        .qty-action { background: transparent; border: none; padding: 4px 12px; color: var(--zomato-red); font-weight: 700; font-size: 18px; }
        .qty-action:hover { background: #FCEBEC; }
        .qty-num { width: 30px; text-align: center; color: var(--zomato-red); font-weight: 700; font-size: 14px; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="container cart-wrapper">
    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="cart-card">
                        <div class="res-info-mini">
                            <img src="${cart.items[0].menuItem.restaurant.imageUrl}" width="60" height="60" class="rounded-3 object-fit-cover">
                            <div>
                                <h5 class="m-0 fw-bold">${cart.items[0].menuItem.restaurant.name}</h5>
                                <p class="text-zomato-gray small m-0">${cart.items[0].menuItem.restaurant.address}</p>
                            </div>
                        </div>

                        <c:forEach items="${cart.items}" var="item">
                            <div class="item-list-row">
                                <span class="${item.menuItem.foodType == 'VEG' ? 'veg-icon' : 'non-veg-icon'}" style="margin-top: 5px;"></span>
                                <div class="flex-grow-1">
                                    <div class="fw-medium">${item.menuItem.name}</div>
                                    <div class="small fw-bold">₹${item.price}</div>
                                </div>
                                <div class="d-flex flex-column align-items-end gap-2">
                                    <div class="qty-control-box">
                                        <form action="${pageContext.request.contextPath}/cart/update" method="POST" class="d-flex m-0">
                                            <input type="hidden" name="cartItemId" value="${item.id}">
                                            <button type="submit" name="quantity" value="${item.quantity - 1}" class="qty-action" ${item.quantity == 1 ? 'disabled' : ''}>&minus;</button>
                                            <div class="qty-num">${item.quantity}</div>
                                            <button type="submit" name="quantity" value="${item.quantity + 1}" class="qty-action">&plus;</button>
                                        </form>
                                    </div>
                                    <div class="fw-bold">₹${item.price * item.quantity}</div>
                                    <a href="${pageContext.request.contextPath}/cart/remove/${item.id}" class="text-zomato-gray x-small text-decoration-none" style="font-size: 11px;">Remove</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="bill-summary">
                        <h5 class="fw-bold mb-4">Bill Details</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-zomato-gray">Item Total</span>
                            <span>₹${total}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-zomato-gray">Delivery Fee</span>
                            <span class="text-success fw-bold">FREE</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-zomato-gray">Taxes & Charges</span>
                            <span>₹${total * 0.05}</span>
                        </div>
                        <hr class="my-3" style="border-style: dashed;">
                        <div class="d-flex justify-content-between mb-4">
                            <h5 class="fw-bold m-0">Grand Total</h5>
                            <h5 class="fw-bold m-0 text-zomato-red">₹${total + (total * 0.05)}</h5>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/orders/checkout" class="btn btn-zomato w-100 py-3 fs-5">Proceed to Checkout</a>
                        
                        <div class="mt-4 p-3 rounded-3" style="background: var(--zomato-bg); border: 1px solid var(--zomato-border);">
                            <div class="d-flex align-items-center gap-3">
                                <i class="fas fa-tags text-success fs-3"></i>
                                <div>
                                    <div class="fw-bold small">Apply Coupon</div>
                                    <div class="text-muted" style="font-size: 11px;">Save up to ₹100 more!</div>
                                </div>
                                <i class="fas fa-chevron-right ms-auto text-muted"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-card text-center py-5">
                <img src="https://b.zmtcdn.com/2d74301241160ee5201c2bdd822941581577713401.png" width="250" class="mb-4 opacity-75">
                <h3 class="fw-bold">Your cart is empty</h3>
                <p class="text-zomato-gray mb-4">Good food is always cooking! Go ahead, order some.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-zomato px-5 py-2">Find Food</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="common/footer.jsp" />

</body>
</html>
