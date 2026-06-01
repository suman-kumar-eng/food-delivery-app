<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Zomato Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .sidebar-link { border-radius: 10px; padding: 12px 15px; text-decoration: none; color: var(--zomato-gray); display: flex; align-items: center; gap: 12px; margin-bottom: 5px; font-weight: 500; }
        .sidebar-link:hover { background: var(--zomato-bg); color: var(--zomato-red); }
        .sidebar-link.active { background: var(--zomato-red); color: white; }
        
        .order-table-card { background: white; border-radius: 12px; overflow: hidden; border: 1px solid var(--zomato-border); box-shadow: 0 1px 10px rgba(0,0,0,0.05); }
        .table thead th { background: #F8F8F8; color: var(--zomato-gray); font-weight: 600; text-transform: uppercase; font-size: 11px; letter-spacing: 1px; padding: 15px 20px; border-bottom: 1px solid var(--zomato-border); }
        .table tbody td { padding: 20px; border-bottom: 1px solid var(--zomato-border); }
        .table tbody tr:last-child td { border-bottom: none; }
        
        .status-pill { padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .status-PLACED { background: #E3F2FD; color: #1976D2; }
        .status-CONFIRMED { background: #FFF3E0; color: #F57C00; }
        .status-OUT_FOR_DELIVERY { background: #F3E5F5; color: #7B1FA2; }
        .status-DELIVERED { background: #E8F5E9; color: #388E3C; }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="container-fluid py-5 px-md-5">
    <div class="row g-4">
        <!-- Sidebar -->
        <div class="col-md-3">
            <div class="bg-white p-4 rounded-4 shadow-sm border">
                <h5 class="fw-bold mb-4 px-2">Zomato Admin</h5>
                <nav class="d-flex flex-column">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link"><i class="fas fa-chart-line"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link"><i class="fas fa-utensils"></i> Restaurants</a>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link"><i class="fas fa-tags"></i> Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/menu-items" class="sidebar-link"><i class="fas fa-hamburger"></i> Menu Items</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link active"><i class="fas fa-receipt"></i> Active Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link"><i class="fas fa-users"></i> Platform Users</a>
                    <a href="${pageContext.request.contextPath}/admin/coupons" class="sidebar-link"><i class="fas fa-percent"></i> Discounts</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="fw-bold m-0">Incoming Orders</h1>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-zomato btn-sm py-2 px-3"><i class="fas fa-filter me-1"></i> Filter</button>
                    <button class="btn btn-zomato btn-sm py-2 px-3"><i class="fas fa-download me-1"></i> Export</button>
                </div>
            </div>

            <div class="order-table-card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date & Time</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="ord">
                                <tr>
                                    <td class="fw-bold text-dark">#${ord.orderNumber}</td>
                                    <td>
                                        <div class="small fw-medium">10 Oct, 2026</div>
                                        <div class="text-zomato-gray x-small">8:45 PM</div>
                                    </td>
                                    <td>
                                        <div class="fw-bold small">${ord.user.firstName} ${ord.user.lastName}</div>
                                        <div class="text-zomato-gray x-small">${ord.user.mobileNumber}</div>
                                    </td>
                                    <td class="fw-bold">₹${ord.finalAmount}</td>
                                    <td class="text-center">
                                        <span class="status-pill status-${ord.status}">
                                            ${ord.status}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm border" type="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-ellipsis-v text-zomato-gray"></i>
                                            </button>
                                            <ul class="dropdown-menu shadow-sm border-0 small">
                                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders/details/${ord.id}"><i class="far fa-eye me-2 text-muted"></i> View Details</a></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="POST">
                                                        <input type="hidden" name="orderId" value="${ord.id}">
                                                        <button type="submit" name="status" value="CONFIRMED" class="dropdown-item py-2 text-warning"><i class="fas fa-check-circle me-2"></i> Mark Confirmed</button>
                                                        <button type="submit" name="status" value="OUT_FOR_DELIVERY" class="dropdown-item py-2 text-primary"><i class="fas fa-motorcycle me-2"></i> Out for Delivery</button>
                                                        <button type="submit" name="status" value="DELIVERED" class="dropdown-item py-2 text-success"><i class="fas fa-check-double me-2"></i> Mark Delivered</button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="mt-4 p-3 bg-white rounded-3 border text-center text-zomato-gray small">
                Showing ${orders.size()} active orders in the pipeline.
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

</body>
</html>
