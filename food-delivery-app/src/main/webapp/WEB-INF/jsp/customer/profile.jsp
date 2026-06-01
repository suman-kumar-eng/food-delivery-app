<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: #f8f8f8; }
        .profile-container { max-width: 900px; margin: 40px auto; }
        .profile-card { background: white; border-radius: 12px; border: 1px solid var(--zomato-border); overflow: hidden; }
        .profile-header { background: linear-gradient(to right, #E23744, #F05A67); padding: 40px; color: white; display: flex; align-items: center; gap: 20px; }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; border: 4px solid rgba(255,255,255,0.3); object-fit: cover; }
        .content-section { padding: 30px; }
        .nav-tabs-zomato { border-bottom: 2px solid #eee; margin-bottom: 30px; }
        .nav-tabs-zomato .nav-link { border: none; font-weight: 500; color: var(--zomato-gray); padding: 12px 20px; margin-bottom: -2px; }
        .nav-tabs-zomato .nav-link.active { color: var(--zomato-red); border-bottom: 2px solid var(--zomato-red); background: none; }
        .form-label-z { font-weight: 600; color: #4F4F4F; margin-bottom: 8px; font-size: 14px; }
        .form-control-z { border: 1px solid #CFD8DC; padding: 12px 15px; border-radius: 8px; font-size: 15px; }
        .form-control-z:focus { border-color: var(--zomato-red); box-shadow: none; }
        .stats-box { background: #fff5f5; border-radius: 12px; padding: 20px; text-align: center; border: 1px solid #fee2e2; }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="container profile-container">
    <div class="profile-card shadow-sm animate-fade-up">
        <div class="profile-header">
            <img src="https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=fff&color=E23744&size=128" class="profile-avatar shadow" alt="Avatar">
            <div>
                <h2 class="fw-bold m-0">${user.firstName} ${user.lastName}</h2>
                <p class="m-0 opacity-75"><i class="fas fa-envelope me-1"></i> ${user.email}</p>
            </div>
            <div class="ms-auto d-flex gap-2">
                <button class="btn btn-light btn-sm rounded-3 py-2 px-3 border" style="color: #1c1c1c; font-weight: 500;">
                    <i class="fas fa-filter me-2 text-muted"></i> Filter
                </button>
                <button class="btn btn-zomato btn-sm rounded-3 py-2 px-3 fw-medium">
                    <i class="fas fa-download me-2"></i> Export
                </button>
            </div>
        </div>

        <div class="content-section">
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <ul class="nav nav-tabs-zomato">
                <li class="nav-item">
                    <a class="nav-link active" href="#"><i class="far fa-user me-2"></i> Edit Profile</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/orders"><i class="fas fa-history me-2"></i> Order History</a>
                </li>
            </ul>

            <form action="${pageContext.request.contextPath}/customer/profile/update" method="POST">
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label-z">First Name</label>
                        <input type="text" name="firstName" value="${user.firstName}" class="form-control form-control-z w-100" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-z">Last Name</label>
                        <input type="text" name="lastName" value="${user.lastName}" class="form-control form-control-z w-100" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-z">Email Address</label>
                        <input type="email" value="${user.email}" class="form-control form-control-z w-100 bg-light" readonly>
                        <div class="form-text mt-1" style="font-size: 11px;">Email cannot be changed</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-z">Mobile Number</label>
                        <input type="tel" name="mobileNumber" value="${user.mobileNumber}" class="form-control form-control-z w-100" required>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label-z">Delivery Address</label>
                        <textarea name="address" rows="3" class="form-control form-control-z w-100" required>${user.address}</textarea>
                    </div>
                    <div class="col-md-12 text-end mt-4">
                        <button type="submit" class="btn btn-zomato px-5 py-2 rounded-3 fw-bold">
                            Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Additional Stats for premium feel -->
    <div class="row mt-4 g-4 animate-fade-up" style="animation-delay: 0.1s;">
        <div class="col-md-4">
            <div class="stats-box shadow-sm">
                <div class="text-zomato-red fs-3 fw-bold mb-1">12</div>
                <div class="text-muted small fw-medium text-uppercase">Total Orders</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stats-box shadow-sm">
                <div class="text-zomato-red fs-3 fw-bold mb-1">₹4,250</div>
                <div class="text-muted small fw-medium text-uppercase">Total Spent</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stats-box shadow-sm">
                <div class="text-zomato-red fs-3 fw-bold mb-1">4.8</div>
                <div class="text-muted small fw-medium text-uppercase">Average Rating</div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
