<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        .login-container { min-height: 80vh; display: flex; align-items: center; justify-content: center; background: #FFF; }
        .login-box { width: 100%; max-width: 448px; padding: 40px; }
        .social-login-btn { border: 1px solid var(--zomato-border); padding: 12px; border-radius: 10px; display: flex; align-items: center; justify-content: center; width: 100%; background: white; transition: 0.2s; font-size: 16px; margin-bottom: 20px; }
        .social-login-btn:hover { background: var(--zomato-bg); }
        .divider { display: flex; align-items: center; text-align: center; color: var(--zomato-gray); margin: 30px 0; }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid var(--zomato-border); }
        .divider:not(:empty)::before { margin-right: .5em; }
        .divider:not(:empty)::after { margin-left: .5em; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="login-container animate-fade-up">
    <div class="login-box shadow-xl border rounded-4 glass-panel">
        <h2 class="mb-4 fw-bold text-dark">Login</h2>
        
        <c:if test="${not empty error}">
            <div class="alert bg-danger-subtle text-danger border-0 rounded-3 small py-3 mb-4">
                <i class="fas fa-exclamation-circle me-2"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Email</label>
                <input type="email" name="email" class="form-control-z w-100" placeholder="e.g. name@example.com" required>
            </div>
            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Password</label>
                <input type="password" name="password" class="form-control-z w-100" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-zomato w-100 fs-5 py-3 rounded-3 shadow-sm">Log in</button>
        </form>

        <div class="divider">or</div>

        <div class="d-grid gap-2">
            <button class="social-login-btn rounded-3">
                <img src="https://b.zmtcdn.com/web_assets/023927d3c0a5ead1398867f13904a0081600863004.png" width="22" class="me-3">
                Continue with Google
            </button>
            <button class="social-login-btn rounded-3">
                <i class="fas fa-envelope me-3 text-muted"></i>
                Continue with Email
            </button>
        </div>
        
        <p class="text-center text-zomato-gray mt-5 mb-0">
            New to Zomato? <a href="${pageContext.request.contextPath}/register" class="text-zomato-red text-decoration-none fw-bold">Create account</a>
        </p>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

</body>
</html>
