<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign up - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        .register-container { min-height: 80vh; display: flex; align-items: center; justify-content: center; background: white; padding-bottom: 50px; }
        .register-box { width: 100%; max-width: 448px; padding: 40px; }
        .social-btn-z { border: 1px solid var(--zomato-border); padding: 12px; border-radius: 10px; display: flex; align-items: center; justify-content: center; width: 100%; background: white; transition: 0.2s; font-size: 16px; margin-bottom: 20px; }
        .social-btn-z:hover { background: var(--zomato-bg); }
        .divider { display: flex; align-items: center; text-align: center; color: var(--zomato-gray); margin: 25px 0; }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid var(--zomato-border); }
        .divider:not(:empty)::before { margin-right: .5em; }
        .divider:not(:empty)::after { margin-left: .5em; }
        .terms-text { font-size: 11px; color: var(--zomato-gray); line-height: 1.4; margin-top: 20px; text-align: center; }
        .terms-text a { color: var(--zomato-red); text-decoration: none; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="register-container animate-fade-up">
    <div class="register-box shadow-xl border rounded-4 glass-panel mt-5">
        <h2 class="mb-4 fw-bold text-dark text-center">Sign up</h2>
        
        <c:if test="${not empty error}">
            <div class="alert bg-danger-subtle text-danger border-0 rounded-3 small py-3 mb-4">
                <i class="fas fa-exclamation-circle me-2"></i> ${error}
            </div>
        </c:if>

        <form:form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="user">
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <label class="form-label small fw-bold text-muted text-uppercase">First Name</label>
                    <form:input path="firstName" class="form-control-z w-100" placeholder="John" required="true" />
                    <form:errors path="firstName" cssClass="text-danger x-small mt-1" />
                </div>
                <div class="col-6">
                    <label class="form-label small fw-bold text-muted text-uppercase">Last Name</label>
                    <form:input path="lastName" class="form-control-z w-100" placeholder="Doe" required="true" />
                    <form:errors path="lastName" cssClass="text-danger x-small mt-1" />
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Email</label>
                <form:input path="email" class="form-control-z w-100" placeholder="john@example.com" required="true" />
                <form:errors path="email" cssClass="text-danger x-small mt-1" />
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Mobile Number</label>
                <form:input path="mobileNumber" class="form-control-z w-100" placeholder="9876543210" required="true" />
                <form:errors path="mobileNumber" cssClass="text-danger x-small mt-1" />
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Password</label>
                <form:input type="password" path="password" class="form-control-z w-100" placeholder="••••••••" required="true" />
                <form:errors path="password" cssClass="text-danger x-small mt-1" />
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted text-uppercase">Role</label>
                <form:select path="role" class="form-control-z w-100 py-3">
                    <form:option value="CUSTOMER">Customer (Order Food)</form:option>
                    <form:option value="ADMIN">Admin (Manage Platform)</form:option>
                </form:select>
            </div>
            
            <div class="d-flex align-items-start gap-3 mb-4">
                <input type="checkbox" required class="form-check-input mt-1 shadow-none" style="width: 18px; height: 18px;">
                <label class="small text-muted" style="line-height:1.2;">I agree to Zomato's <a href="#" class="text-zomato-red">Terms</a>, <a href="#" class="text-zomato-red">Privacy Policy</a> and <a href="#" class="text-zomato-red">Content Policies</a></label>
            </div>

            <button type="submit" class="btn btn-zomato w-100 fs-5 py-3 rounded-3 shadow-sm">Create account</button>
        </form:form>

        <div class="divider">or</div>

        <button class="social-btn-z rounded-3 mb-5">
            <img src="https://b.zmtcdn.com/web_assets/023927d3c0a5ead1398867f13904a0081600863004.png" width="22" class="me-3">
            Continue with Google
        </button>
        
        <p class="text-center text-zomato-gray mt-5 border-top pt-4 mb-0">
            Already have an account? <a href="${pageContext.request.contextPath}/login" class="text-zomato-red text-decoration-none fw-bold">Log in</a>
        </p>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

</body>
</html>
