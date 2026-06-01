<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Summary - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .order-card { background: white; border-radius: 12px; padding: 30px; margin-bottom: 30px; box-shadow: 0 1px 10px rgba(0,0,0,0.05); }
        .status-tracker { display: flex; justify-content: space-between; position: relative; margin-bottom: 40px; padding: 0 40px; }
        .status-tracker::before { content: ''; position: absolute; top: 15px; left: 60px; right: 60px; height: 2px; background: #E8E8E8; z-index: 1; }
        .status-step { position: relative; z-index: 2; text-align: center; }
        .status-icon { width: 32px; height: 32px; border-radius: 50%; background: #E8E8E8; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; color: white; border: 4px solid white; transition: 0.3s; }
        .status-step.active .status-icon { background: var(--zomato-green); }
        .status-step.active .status-text { color: var(--zomato-green); font-weight: 500; }
        .status-text { font-size: 13px; color: var(--zomato-gray); }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="container py-5" style="max-width: 800px;">
    
    <c:if test="${param.placed == 'true'}">
        <div class="alert alert-success border-0 shadow-sm rounded-4 p-4 mb-4 d-flex align-items-center animate-fade-up">
            <div class="bg-white text-success rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" style="width: 50px; height: 50px;">
                <i class="fas fa-check-circle fs-3"></i>
            </div>
            <div>
                <h5 class="fw-bold mb-1 text-success">Order placed successfully!</h5>
                <p class="mb-0 small text-success opacity-75">Your payment was securely processed and the restaurant has received your order.</p>
            </div>
        </div>
    </c:if>

    <div class="order-card animate-fade-up">
        <div class="d-flex justify-content-between align-items-start mb-5 pb-4 border-bottom">
            <div>
                <h3 class="fw-bold mb-1">Order Summary</h3>
                <p class="text-zomato-gray m-0 small">Order ID: <span class="text-dark fw-bold">#${order.orderNumber}</span></p>
                <p class="text-zomato-gray m-0 small mt-1">Payment Method: <span class="badge bg-light text-dark border">${order.paymentMethod}</span></p>
                <c:if test="${not empty order.paymentTransactionId}">
                    <p class="text-zomato-gray m-0 small mt-1">Transaction Id: <span class="text-muted fw-bold">${order.paymentTransactionId}</span></p>
                </c:if>
            </div>
            <div class="text-end">
                <span class="rating-badge py-2 px-3 fw-bold fs-6 ${order.status == 'DELIVERED' ? 'bg-success' : 'bg-primary'}">
                    ${order.status}
                </span>
                <p class="text-zomato-gray small m-0 mt-2">
                    Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM, h:mm a" />
                </p>
            </div>
        </div>

        <!-- Status Tracker -->
        <div class="status-tracker">
            <div class="status-step active">
                <div class="status-icon"><i class="fas fa-check small"></i></div>
                <div class="status-text">Placed</div>
            </div>
            <div class="status-step active">
                <div class="status-icon"><i class="fas fa-check small"></i></div>
                <div class="status-text">Confirmed</div>
            </div>
            <div class="status-step ${order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="status-icon"><i class="fas fa-utensils small"></i></div>
                <div class="status-text">Prepared</div>
            </div>
            <div class="status-step ${order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="status-icon"><i class="fas fa-motorcycle small"></i></div>
                <div class="status-text">Delivered</div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-7 border-end pe-4">
                <h5 class="fw-bold mb-4">Items Ordered</h5>
                <c:forEach items="${order.orderItems}" var="item">
                    <div class="d-flex align-items-center mb-4">
                        <img src="${item.menuItem.imageUrl}" class="rounded-3 shadow-sm object-fit-cover" width="60" height="60">
                        <div class="ms-3 flex-grow-1">
                            <div class="fw-bold small mb-1">${item.menuItem.name}</div>
                            <div class="text-zomato-gray x-small">${item.quantity} x ₹${item.price}</div>
                        </div>
                        <div class="fw-bold small">₹${item.price * item.quantity}</div>
                    </div>
                </c:forEach>
            </div>

            <div class="col-md-5 ps-4">
                <h5 class="fw-bold mb-4">Bill Details</h5>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-zomato-gray">Item Total</span>
                    <span>₹${order.totalAmount}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-zomato-gray">Taxes & Charges</span>
                    <span>₹${order.totalAmount * 0.05}</span>
                </div>
                <c:if test="${order.discountAmount > 0}">
                    <div class="d-flex justify-content-between mb-2 small text-success">
                        <span>Discount</span>
                        <span>-₹${order.discountAmount}</span>
                    </div>
                </c:if>
                <hr class="my-3" style="border-style: dotted;">
                <div class="d-flex justify-content-between mb-4">
                    <h5 class="fw-bold m-0">Paid amount</h5>
                    <h5 class="fw-bold m-0 text-zomato-red">₹${order.finalAmount}</h5>
                </div>

                <hr class="my-3">
                
                <h6 class="fw-bold mb-2 small">Deliver to</h6>
                <div class="text-dark fw-bold small mb-1">${order.user.firstName}</div>
                <div class="text-zomato-gray x-small">${order.deliveryAddress.street}, ${order.deliveryAddress.city}</div>
            </div>
        </div>
        
        <div class="mt-5 pt-4 text-center border-top">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-zomato px-5 py-2 me-3">Back to Home</a>
            <button class="btn btn-zomato px-5 py-2" onclick="window.print()"><i class="fas fa-download me-2"></i>Download Receipt</button>
        </div>
    </div>

    <!-- Help Section -->
    <div class="order-card p-4">
        <div class="d-flex align-items-center gap-3">
            <div class="bg-primary-subtle text-primary p-3 rounded-circle">
                <i class="fas fa-headset fs-4"></i>
            </div>
            <div>
                <h6 class="fw-bold mb-1">Need help with your order?</h6>
                <p class="text-zomato-gray small m-0">Chat with us for any issues like missing items, wrong food etc.</p>
            </div>
            <button class="btn btn-outline-primary ms-auto px-4 py-2 small fw-bold">HELP</button>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

</body>
</html>
