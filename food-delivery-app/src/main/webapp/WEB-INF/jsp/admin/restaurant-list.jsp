<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants - Zomato Admin</title>
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
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link active"><i class="fas fa-utensils"></i> Restaurants</a>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link"><i class="fas fa-tags"></i> Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/menu-items" class="sidebar-link"><i class="fas fa-hamburger"></i> Menu Items</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link"><i class="fas fa-receipt"></i> Active Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link"><i class="fas fa-users"></i> Platform Users</a>
                    <a href="${pageContext.request.contextPath}/admin/coupons" class="sidebar-link"><i class="fas fa-percent"></i> Discounts</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="fw-bold m-0">Restaurant Partners</h1>
                <a href="${pageContext.request.contextPath}/admin/restaurants/add" class="btn btn-zomato py-2 px-4 shadow-sm"><i class="fas fa-plus me-2"></i> Add Restaurant</a>
            </div>

            <div class="order-table-card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Restaurant</th>
                                <th>Location</th>
                                <th>Contact</th>
                                <th>Rating</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${restaurants}" var="res">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${res.imageUrl}" class="rounded-3 me-3 object-fit-cover" width="50" height="50">
                                            <div>
                                                <div class="fw-bold small">${res.name}</div>
                                                <span class="x-small px-2 py-0 border rounded-pill ${res.active ? 'text-success border-success' : 'text-danger border-danger'}">${res.active ? 'Active' : 'Inactive'}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td><div class="text-zomato-gray small text-truncate" style="max-width: 150px;">${res.address}</div></td>
                                    <td><div class="small fw-medium">${res.phoneNumber}</div></td>
                                    <td>
                                        <span class="rating-badge small">${res.rating}<i class="fas fa-star ms-1" style="font-size: 10px;"></i></span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/menu-items?restaurantId=${res.id}" 
                                               class="btn btn-light btn-sm border text-primary" title="Manage Menu">
                                               <i class="fas fa-hamburger me-1"></i>Menu
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/restaurants/edit/${res.id}" class="btn btn-light btn-sm border" title="Edit"><i class="fas fa-edit text-muted"></i></a>
                                            <form action="${pageContext.request.contextPath}/admin/restaurants/delete/${res.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this restaurant?');">
                                                <button type="submit" class="btn btn-light btn-sm border text-danger" title="Delete"><i class="fas fa-trash-alt"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="mt-4 p-3 bg-white rounded-3 border text-center text-zomato-gray small">
                Showing ${restaurants.size()} onboarded restaurant partners.
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

</body>
</html>
