<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Server Error - FoodDelivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">
    <div class="text-center">
        <h1 class="display-1 fw-bold text-danger">500</h1>
        <h2 class="fw-bold mb-4">Internal Server Error</h2>
        <p class="text-muted mb-5 fs-5">Something went wrong on our end. Please try again later.</p>
        <p class="text-danger small mb-5">${message}</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-dark px-5 py-3 rounded-pill fw-bold">BACK TO HOME</a>
    </div>
</body>
</html>
