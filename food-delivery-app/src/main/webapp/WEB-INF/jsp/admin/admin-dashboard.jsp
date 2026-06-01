<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .stat-card { border-radius: 15px; border: 1px solid var(--zomato-border); padding: 25px; background: white; transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .sidebar-link { border-radius: 10px; padding: 12px 15px; text-decoration: none; color: var(--zomato-gray); display: flex; align-items: center; gap: 12px; margin-bottom: 5px; font-weight: 500; }
        .sidebar-link:hover { background: var(--zomato-bg); color: var(--zomato-red); }
        .sidebar-link.active { background: var(--zomato-red); color: white; }
        .transition-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .transition-hover:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link active"><i class="fas fa-chart-line"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link"><i class="fas fa-utensils"></i> Restaurants</a>
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
            <div class="d-flex justify-content-between align-items-center mb-5">
                <h1 class="fw-bold mb-0">Overview</h1>
                <div class="text-zomato-gray fw-medium"><i class="far fa-calendar-alt me-2"></i> 09 March 2026</div>
            </div>

                <div class="row g-4 mb-5 animate-fade-up">
                    <div class="col-md-3">
                        <div class="stat-card shadow-sm">
                            <div class="text-zomato-gray small fw-bold text-uppercase mb-2">Total Restaurants</div>
                            <div class="d-flex align-items-center justify-content-between">
                                <h1 class="fw-bold m-0">${restaurantCount}</h1>
                                <div class="bg-primary bg-opacity-10 p-3 rounded-circle text-primary"><i class="fas fa-store fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card shadow-sm">
                            <div class="text-zomato-gray small fw-bold text-uppercase mb-2">Lifetime Orders</div>
                            <div class="d-flex align-items-center justify-content-between">
                                <h1 class="fw-bold m-0">${orderCount}</h1>
                                <div class="bg-success bg-opacity-10 p-3 rounded-circle text-success"><i class="fas fa-shopping-bag fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card shadow-sm">
                            <div class="text-zomato-gray small fw-bold text-uppercase mb-2">Total Categories</div>
                            <div class="d-flex align-items-center justify-content-between">
                                <h1 class="fw-bold m-0">${categoryCount}</h1>
                                <div class="bg-warning bg-opacity-10 p-3 rounded-circle text-warning"><i class="fas fa-tags fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card shadow-sm">
                            <div class="text-zomato-gray small fw-bold text-uppercase mb-2">Menu Items</div>
                            <div class="d-flex align-items-center justify-content-between">
                                <h1 class="fw-bold m-0">${menuItemCount}</h1>
                                <div class="bg-info bg-opacity-10 p-3 rounded-circle text-info"><i class="fas fa-utensils fs-4"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="row g-4 mb-5 animate-fade-up" style="animation-delay: 0.1s;">
                    <div class="col-md-8">
                        <div class="bg-white p-4 rounded-4 shadow-sm border h-100">
                            <h5 class="fw-bold mb-4">Orders Trend (Last 7 Days)</h5>
                            <canvas id="ordersChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="bg-white p-4 rounded-4 shadow-sm border h-100">
                            <h5 class="fw-bold mb-4">Popular Categories</h5>
                            <canvas id="categoryChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Quick Management Tiles -->
                <h4 class="fw-bold mb-4 animate-fade-up" style="animation-delay: 0.2s;">Quick Actions</h4>
                <div class="row g-4 mb-5 animate-fade-up" style="animation-delay: 0.25s;">
                    <div class="col-md-4">
                        <a href="${pageContext.request.contextPath}/admin/menu-items/add" class="text-decoration-none">
                            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 text-center transition-hover" style="background: #FCEEEC;">
                                <div class="bg-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 shadow-sm" style="width: 50px; height: 50px;">
                                    <i class="fas fa-plus text-zomato-red fs-4"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">Add Menu Item</h5>
                                <p class="text-muted small mb-0">Add new food images, prices, and names instantly.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="text-decoration-none">
                            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 text-center transition-hover" style="background: #E8F5E9;">
                                <div class="bg-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 shadow-sm" style="width: 50px; height: 50px;">
                                    <i class="fas fa-clipboard-list text-success fs-4"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">Manage Orders</h5>
                                <p class="text-muted small mb-0">Track and update orders placed by your customers.</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="${pageContext.request.contextPath}/admin/restaurants" class="text-decoration-none">
                            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 text-center transition-hover" style="background: #E3F2FD;">
                                <div class="bg-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 shadow-sm" style="width: 50px; height: 50px;">
                                    <i class="fas fa-store text-primary fs-4"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">Restaurants</h5>
                                <p class="text-muted small mb-0">Update restaurant details and availability.</p>
                            </div>
                        </a>
                    </div>
                </div>

            <!-- Insight Section -->
            <div class="bg-dark text-white p-5 rounded-4 shadow-lg position-relative overflow-hidden animate-fade-up" style="animation-delay: 0.3s;">
                <div class="position-relative z-1">
                    <h3 class="fw-bold mb-3">Welcome back, Admin</h3>
                    <p class="fs-5 text-secondary opacity-75 mb-4">The platform is running smoothly. You have <strong>${orderCount} pending orders</strong> that need confirmation.</p>
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-zomato px-5 py-3 rounded-3 fw-bold">Manage Orders</a>
                        <button class="btn btn-outline-light px-5 py-3 rounded-3 fw-bold">View Reports</button>
                    </div>
                </div>
                <i class="fas fa-rocket position-absolute opacity-10" style="bottom: -20px; right: 20px; font-size: 150px;"></i>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Orders Chart
    const ctxOrders = document.getElementById('ordersChart').getContext('2d');
    new Chart(ctxOrders, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Orders',
                data: [12, 19, 3, 5, 2, 3, 9],
                borderColor: '#E23744',
                backgroundColor: 'rgba(226, 55, 68, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true }, x: { grid: { display: false } } }
        }
    });

    // Category Chart
    const ctxCat = document.getElementById('categoryChart').getContext('2d');
    new Chart(ctxCat, {
        type: 'doughnut',
        data: {
            labels: ['Biryani', 'Pizza', 'Chinese', 'Desserts'],
            datasets: [{
                data: [40, 20, 25, 15],
                backgroundColor: ['#E23744', '#F4A261', '#2A9D8F', '#264653'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'bottom' } }
        }
    });
</script>
</body>
</html>
