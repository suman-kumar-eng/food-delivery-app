<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Zomato Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .sidebar-link { border-radius: 10px; padding: 12px 15px; text-decoration: none; color: var(--zomato-gray); display: flex; align-items: center; gap: 12px; margin-bottom: 5px; font-weight: 500; }
        .sidebar-link:hover { background: var(--zomato-bg); color: var(--zomato-red); }
        .sidebar-link.active { background: var(--zomato-red); color: white; }
        .category-card { background: white; border-radius: 16px; border: 1px solid var(--zomato-border); transition: 0.3s; }
        .category-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
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
                    <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link active"><i class="fas fa-tags"></i> Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/menu-items" class="sidebar-link"><i class="fas fa-hamburger"></i> Menu Items</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link"><i class="fas fa-receipt"></i> Active Orders</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="fw-bold m-0">Menu Categories</h1>
                <button type="button" class="btn btn-zomato py-2 px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus me-2"></i>Add Category
                </button>
            </div>

            <div class="row g-4">
                <c:forEach items="${categories}" var="cat">
                    <div class="col-md-4">
                        <div class="category-card p-4 d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-light-red p-3 rounded-circle text-zomato-red">
                                    <i class="fas fa-tag fs-5"></i>
                                </div>
                                <div>
                                    <h5 class="m-0 fw-bold">${cat.name}</h5>
                                    <span class="text-muted small">Active Category</span>
                                </div>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-light btn-sm border-0 bg-transparent" type="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-ellipsis-v text-muted"></i>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-3">
                                    <li><a class="dropdown-item py-2" href="#"><i class="fas fa-edit me-2 text-primary"></i> Edit</a></li>
                                    <li><a class="dropdown-item py-2 text-danger" href="#"><i class="fas fa-trash-alt me-2"></i> Delete</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Add New Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories/save" method="POST">
                <div class="modal-body py-4">
                    <label class="form-label fw-bold small text-muted text-uppercase">Category Name</label>
                    <input type="text" name="name" class="form-control form-control-z w-100" placeholder="e.g. North Indian" required>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-zomato px-4">Save Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
