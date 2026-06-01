<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit/Add Restaurant - Zomato Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .sidebar-link { border-radius: 10px; padding: 12px 15px; text-decoration: none; color: var(--zomato-gray); display: flex; align-items: center; gap: 12px; margin-bottom: 5px; font-weight: 500; }
        .sidebar-link:hover { background: var(--zomato-bg); color: var(--zomato-red); }
        .sidebar-link.active { background: var(--zomato-red); color: white; }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="container-fluid py-5 px-md-5">
    <div class="row g-4">
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

        <div class="col-md-9">
            <div class="bg-white p-5 rounded-4 border shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <h2 class="fw-bold m-0">${empty restaurant.id ? 'Add New' : 'Edit'} Restaurant</h2>
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn-outline-zomato px-4">Cancel</a>
                </div>

                <form:form action="${pageContext.request.contextPath}/admin/restaurants/save" method="POST" modelAttribute="restaurant">
                    <form:hidden path="id"/>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">Restaurant Name</label>
                            <form:input path="name" class="form-control-z w-100" placeholder="e.g. Paradise Biryani" required="true"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">Phone Number</label>
                            <form:input path="phoneNumber" class="form-control-z w-100" placeholder="e.g. 9876543210"/>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">Image URL</label>
                            <form:input path="imageUrl" class="form-control-z w-100" placeholder="https://..." required="true"/>
                            <div class="form-text small">Provide a direct link to the restaurant cover image.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted text-uppercase">Customer Rating</label>
                            <form:input type="number" step="0.1" max="5.0" min="0" path="rating" class="form-control-z w-100" placeholder="e.g. 4.5"/>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold small text-muted text-uppercase">Location / Address</label>
                        <form:input path="address" class="form-control-z w-100" placeholder="e.g. 123 Main Street, Hyderabad"/>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold small text-muted text-uppercase">Description / Cuisines</label>
                        <form:textarea path="description" class="form-control-z w-100" rows="3" placeholder="e.g. Famous for Biryani and North Indian Food..."/>
                    </div>

                    <div class="mb-5 bg-light p-3 rounded-3 border d-flex gap-3 align-items-center">
                        <label class="form-label fw-bold small text-muted text-uppercase m-0">Status:</label>
                        <div class="form-check m-0">
                            <form:radiobutton path="active" value="true" class="form-check-input" id="statusActive"/>
                            <label class="form-check-label fw-medium text-success" for="statusActive">Active (Visible)</label>
                        </div>
                        <div class="form-check m-0 ms-3">
                            <form:radiobutton path="active" value="false" class="form-check-input" id="statusInactive"/>
                            <label class="form-check-label fw-medium text-danger" for="statusInactive">Inactive (Hidden)</label>
                        </div>
                    </div>

                    <div class="text-end border-top pt-4">
                        <button type="submit" class="btn btn-zomato px-5 py-3 fs-5 fw-bold rounded-3 shadow-sm">
                            <i class="fas fa-save me-2"></i> Save Restaurant
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

</body>
</html>
