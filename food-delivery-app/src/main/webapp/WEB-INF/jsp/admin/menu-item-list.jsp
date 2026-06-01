<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Menu Items - Zomato Admin</title>
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
        .table tbody td { padding: 15px 20px; border-bottom: 1px solid var(--zomato-border); vertical-align: middle; }
        .table tbody tr:last-child td { border-bottom: none; }
        .menu-img { width: 64px; height: 64px; object-fit: cover; border-radius: 10px; transition: transform 0.3s ease; }
        .menu-img:hover { transform: scale(1.15); }
        .badge-veg { background: #48c479; color: white; font-size: 10px; padding: 3px 8px; border-radius: 50px; }
        .badge-nonveg { background: #e44; color: white; font-size: 10px; padding: 3px 8px; border-radius: 50px; }
        .price-tag { font-weight: 700; color: #222; }
        .offer-price { color: var(--zomato-red); font-size: 12px; }
        .filter-bar { background: white; border-radius: 12px; padding: 16px 20px; border: 1px solid var(--zomato-border); margin-bottom: 20px; }
        .item-hover:hover { background: #fef9f9; }
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
                    <a href="${pageContext.request.contextPath}/admin/menu-items" class="sidebar-link active"><i class="fas fa-hamburger"></i> Menu Items</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link"><i class="fas fa-receipt"></i> Active Orders</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="fw-bold m-0">Menu Items</h1>
                    <p class="text-muted small mt-1 mb-0">${menuItems.size()} items found</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/menu-items/add<c:if test='${selectedRestaurantId != null}'>?restaurantId=${selectedRestaurantId}</c:if>" 
                   class="btn btn-zomato py-2 px-4 shadow-sm">
                    <i class="fas fa-plus me-2"></i>Add Menu Item
                </a>
            </div>

            <!-- Filter Bar -->
            <div class="filter-bar d-flex align-items-center gap-3 flex-wrap">
                <i class="fas fa-filter text-muted"></i>
                <span class="fw-medium text-muted small">Filter by Restaurant:</span>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/admin/menu-items"
                       class="btn btn-sm ${selectedRestaurantId == null ? 'btn-zomato' : 'btn-outline-secondary'}">All</a>
                    <c:forEach items="${restaurants}" var="res">
                        <a href="${pageContext.request.contextPath}/admin/menu-items?restaurantId=${res.id}"
                           class="btn btn-sm ${selectedRestaurantId == res.id ? 'btn-zomato' : 'btn-outline-secondary'}">${res.name}</a>
                    </c:forEach>
                </div>
            </div>

            <div class="order-table-card">
                <c:choose>
                    <c:when test="${empty menuItems}">
                        <div class="text-center py-5 text-muted">
                            <i class="fas fa-hamburger fa-3x mb-3 opacity-25"></i>
                            <p class="fw-medium">No menu items found.</p>
                            <a href="${pageContext.request.contextPath}/admin/menu-items/add" class="btn btn-zomato mt-2">Add First Item</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Item</th>
                                        <th>Restaurant</th>
                                        <th>Type</th>
                                        <th>Price</th>
                                        <th>Category</th>
                                        <th>Stock</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${menuItems}" var="item">
                                        <tr class="item-hover">
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <c:set var="finalImageUrl" value="${item.imageUrl}" />
                                                    <c:if test="${not empty item.imageUrl && item.imageUrl.startsWith('/')}">
                                                        <c:set var="finalImageUrl" value="${pageContext.request.contextPath}${item.imageUrl}" />
                                                    </c:if>
                                                    <img src="${finalImageUrl}" class="menu-img" 
                                                         alt="${item.name}"
                                                         onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'">
                                                    <div>
                                                        <div class="fw-bold small ${!item.available ? 'text-muted' : ''}">${item.name}</div>
                                                        <div class="text-muted" style="font-size:11px; max-width:180px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${item.description}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="small fw-medium">${item.restaurant.name}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.foodType == 'VEG'}">
                                                        <span class="badge-veg"><i class="fas fa-leaf me-1"></i>VEG</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-nonveg"><i class="fas fa-drumstick-bite me-1"></i>NON-VEG</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="price-tag">₹${item.price}</div>
                                                <c:if test="${item.offerPrice != null}">
                                                    <div class="offer-price"><i class="fas fa-tag me-1"></i>₹${item.offerPrice}</div>
                                                </c:if>
                                            </td>
                                            <td><span class="badge bg-light text-dark border">${item.category.name}</span></td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin/menu-items/toggle-availability/${item.id}" method="POST">
                                                    <input type="hidden" name="restaurantId" value="${selectedRestaurantId}">
                                                    <c:choose>
                                                        <c:when test="${item.available}">
                                                            <button type="submit" class="btn btn-sm btn-success py-1 px-2" style="font-size: 10px;">
                                                                <i class="fas fa-check-circle me-1"></i>IN STOCK
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" class="btn btn-sm btn-danger py-1 px-2" style="font-size: 10px;">
                                                                <i class="fas fa-times-circle me-1"></i>OUT OF STOCK
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/menu-items/edit/${item.id}" 
                                                       class="btn btn-light btn-sm border" title="Edit">
                                                        <i class="fas fa-edit text-primary"></i>
                                                    </a>
                                                    <form method="POST" action="${pageContext.request.contextPath}/admin/menu-items/delete/${item.id}" 
                                                          onsubmit="return confirm('Delete this menu item?')">
                                                        <input type="hidden" name="restaurantId" value="${selectedRestaurantId}">
                                                        <button type="submit" class="btn btn-light btn-sm border" title="Delete">
                                                            <i class="fas fa-trash-alt text-danger"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
