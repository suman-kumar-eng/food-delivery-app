<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg); }
        .order-card { background: white; border-radius: 12px; margin-bottom: 24px; transition: transform 0.2s; border: 1px solid var(--zomato-border); overflow: hidden; }
        .order-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .order-status { font-size: 13px; font-weight: 600; text-transform: uppercase; padding: 4px 10px; border-radius: 4px; }
        .status-PENDING { background: #FFF3E0; color: #E65100; }
        .status-CONFIRMED { background: #E8F5E9; color: #2E7D32; }
        .status-DELIVERED { background: #E3F2FD; color: #1565C0; }
        .status-CANCELLED { background: #FFEBEE; color: #C62828; }
        .restaurant-logo { width: 60px; height: 60px; border-radius: 8px; object-fit: cover; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="container py-5">
    <div class="row">
        <div class="col-lg-3 d-none d-lg-block">
            <div class="bg-white p-4 rounded-4 shadow-sm border">
                <h5 class="fw-bold mb-4">My Account</h5>
                <nav class="d-flex flex-column gap-3">
                    <a href="${pageContext.request.contextPath}/customer/profile" class="text-zomato-gray text-decoration-none fw-medium"><i class="far fa-user me-2"></i> Profile</a>
                    <a href="${pageContext.request.contextPath}/orders" class="text-zomato-red text-decoration-none fw-bold border-start border-3 border-danger ps-3"><i class="fas fa-receipt me-2"></i> Orders</a>
                    <a href="${pageContext.request.contextPath}/addresses" class="text-zomato-gray text-decoration-none fw-medium"><i class="far fa-address-book me-2"></i> Addresses</a>
                    <a href="${pageContext.request.contextPath}/wishlist" class="text-zomato-gray text-decoration-none fw-medium"><i class="far fa-heart me-2"></i> Wishlist</a>
                </nav>
            </div>
        </div>

        <div class="col-lg-9 animate-fade-up">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold m-0">My Orders</h2>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-zomato py-2 px-3 fs-6 d-flex align-items-center gap-2">
                        <i class="fas fa-filter text-muted"></i> Filter
                    </button>
                    <button class="btn btn-zomato py-2 px-3 fs-6 d-flex align-items-center gap-2">
                        <i class="fas fa-download"></i> Export
                    </button>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach items="${orders}" var="order">
                        <div class="order-card p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="d-flex gap-3">
                                    <div class="bg-light p-1 rounded-3">
                                        <img src="https://ui-avatars.com/api/?name=${order.orderItems[0].menuItem.restaurant.name}&background=f8f8f8&color=E23744&bold=true" class="restaurant-logo">
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-1">${order.orderItems[0].menuItem.restaurant.name}</h5>
                                        <div class="text-zomato-gray small">${order.orderItems[0].menuItem.restaurant.address}</div>
                                        <div class="text-zomato-gray x-small mt-1">#${order.orderNumber} | <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, h:mm a" /></div>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <span class="order-status status-${order.status}">${order.status}</span>
                                    <h5 class="fw-bold mt-2 mb-0">₹${order.finalAmount}</h5>
                                </div>
                            </div>
                            
                            <hr class="my-3 opacity-50">
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-zomato-gray small">
                                    <c:forEach items="${order.orderItems}" var="item" varStatus="loop">
                                        ${item.quantity} x ${item.menuItem.name}${not loop.last ? ', ' : ''}
                                    </c:forEach>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/orders/${order.id}" class="btn btn-outline-zomato py-1 px-3 fs-6">View Details</a>
                                    <button class="btn btn-zomato py-1 px-3 fs-6">Reorder</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="bg-white p-5 rounded-4 text-center border shadow-sm">
                        <img src="https://b.zmtcdn.com/web_assets/3e680a370e2417f7d4681600c3c861e61617304313.png" width="150" class="mb-4 opacity-50">
                        <h4 class="fw-bold">No orders yet</h4>
                        <p class="text-zomato-gray mb-4">You haven't placed any orders yet. Go ahead and discover the best food around you!</p>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-zomato px-5 py-2 fs-5">Browse Restaurants</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

</body>
</html>
