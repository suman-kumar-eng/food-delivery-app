<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Best Restaurants in Hyderabad - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        .filter-section { border-bottom: 1px solid var(--zomato-border); padding: 15px 0; background: white; position: sticky; top: 72px; z-index: 100; }
        .filter-pill { border: 1px solid var(--zomato-border); border-radius: 8px; padding: 6px 15px; font-size: 14px; color: var(--zomato-gray); margin-right: 12px; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .filter-pill:hover, .filter-pill.active { background: var(--zomato-bg); border-color: var(--zomato-gray); }
        
        .res-card-list { transition: 0.3s; padding: 10px; border-radius: 15px; }
        .res-card-list:hover { background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transform: translateY(-3px); }
        .res-img-wrapper { position: relative; height: 180px; width: 100%; overflow: hidden; border-radius: 12px; }
        .res-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }
        .res-offer { position: absolute; bottom: 0; left: 0; background: #256fef; color: white; width: 100%; padding: 4px 10px; font-size: 12px; font-weight: 600; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<!-- Collections Section -->
<div class="bg-white py-5 mb-4">
    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold fs-1 m-0">Collections</h2>
                <p class="text-zomato-gray fs-5 mb-0">Explore curated lists of top restaurants in Hyderabad</p>
            </div>
            <a href="#" class="text-zomato-red text-decoration-none fw-medium d-flex align-items-center">
                All collections <i class="fas fa-caret-right ms-2 mt-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/restaurants?search=Trending" class="text-decoration-none">
                    <div class="collection-card">
                        <img src="https://images.unsplash.com/photo-1543353071-873f17a7a088?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Trending">
                        <div class="collection-overlay">
                            <h5 class="mb-0 fw-bold">Trending This Week</h5>
                            <span class="small opacity-90">30 Places <i class="fas fa-caret-right x-small ms-1"></i></span>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/restaurants?search=Best" class="text-decoration-none">
                    <div class="collection-card">
                        <img src="https://images.unsplash.com/photo-1528605248644-14dd04022da1?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Best">
                        <div class="collection-overlay">
                            <h5 class="mb-0 fw-bold">Best of Hyderabad</h5>
                            <span class="small opacity-90">45 Places <i class="fas fa-caret-right x-small ms-1"></i></span>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/restaurants?search=Dessert" class="text-decoration-none">
                    <div class="collection-card">
                        <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Desserts">
                        <div class="collection-overlay">
                            <h5 class="mb-0 fw-bold">Dessert Therapy</h5>
                            <span class="small opacity-90">22 Places <i class="fas fa-caret-right x-small ms-1"></i></span>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/restaurants?search=New" class="text-decoration-none">
                    <div class="collection-card">
                        <img src="https://images.unsplash.com/photo-1551183053-bf91a1d81141?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="New">
                        <div class="collection-overlay">
                            <h5 class="mb-0 fw-bold">Newly Opened</h5>
                            <span class="small opacity-90">12 Places <i class="fas fa-caret-right x-small ms-1"></i></span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Sticky Filters -->
<div class="filter-section shadow-sm mb-5">
    <div class="container d-flex overflow-auto hide-scrollbar py-2">
        <div class="filter-pill"><i class="fas fa-sliders-h text-muted"></i> Filters</div>
        <div class="filter-pill">Rating 4.0+</div>
        <div class="filter-pill">Pure Veg</div>
        <div class="filter-pill">Cuisines <i class="fas fa-chevron-down x-small ms-1 opacity-50"></i></div>
        <div class="filter-pill">More filters <i class="fas fa-chevron-down x-small ms-1 opacity-50"></i></div>
    </div>
</div>

<div class="container py-3">
    <div class="mb-5 animate-fade-up">
        <h1 class="fw-bold fs-2 mb-1">Best Food in Hyderabad</h1>
        <p class="text-zomato-gray fs-5">Discover the top restaurants, cafes, and bars in Hyderabad</p>
    </div>

    <!-- Main Service Tabs -->
    <div class="d-flex border-bottom mb-4 hide-scrollbar overflow-auto">
        <div class="z-tab active d-flex align-items-center gap-2 px-4 py-3">
            <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; background: #fcecec !important;">
                <i class="fas fa-bicycle text-zomato-red fs-5"></i>
            </div>
            <span class="fs-5 fw-medium text-zomato-red">Delivery</span>
        </div>
        <div class="z-tab d-flex align-items-center gap-2 px-4 py-3">
            <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                <i class="fas fa-utensils text-muted fs-5"></i>
            </div>
            <span class="fs-5 fw-medium text-muted">Dining Out</span>
        </div>
        <div class="z-tab d-flex align-items-center gap-2 px-4 py-3">
            <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                <i class="fas fa-glass-martini-alt text-muted fs-5"></i>
            </div>
            <span class="fs-5 fw-medium text-muted">Nightlife</span>
        </div>
    </div>

    <div class="row g-5">
        <!-- New Section: Recommended Items (DISHES) -->
        <c:if test="${not empty matchingItems}">
            <div class="col-12 mb-4 animate-fade-up">
                <hr class="mb-5 opacity-10">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h3 class="fw-bold fs-3 m-0 text-capitalize">${searchTerm} Cravings?</h3>
                    <div class="d-flex gap-2">
                        <span class="badge bg-light text-success border border-success-subtle px-3 py-2 rounded-pill"><span class="veg-icon me-1"></span> Pure Veg</span>
                        <span class="badge bg-light text-danger border border-danger-subtle px-3 py-2 rounded-pill"><span class="non-veg-icon me-1"></span> Non-Veg</span>
                    </div>
                </div>

                <!-- VEG Group -->
                <c:set var="hasVeg" value="false" />
                <c:forEach items="${matchingItems}" var="item">
                    <c:if test="${item.foodType == 'VEG'}"><c:set var="hasVeg" value="true" /></c:if>
                </c:forEach>
                
                <c:if test="${hasVeg}">
                    <h5 class="fw-bold mb-3 text-success d-flex align-items-center">
                        <span class="veg-icon me-2"></span> Vegetarian ${searchTerm}
                    </h5>
                    <div class="row g-4 mb-5">
                        <c:forEach items="${matchingItems}" var="item">
                            <c:if test="${item.foodType == 'VEG'}">
                                <div class="col-md-3">
                                    <div class="featured-item-card h-100 shadow-sm border-0 rounded-4 overflow-hidden bg-white">
                                        <div class="item-img-wrap" style="height: 180px; position: relative;">
                                            <c:set var="finalItemImg" value="${item.imageUrl}" />
                                            <c:if test="${not empty item.imageUrl && item.imageUrl.startsWith('/')}">
                                                <c:set var="finalItemImg" value="${pageContext.request.contextPath}${item.imageUrl}" />
                                            </c:if>
                                            <img src="${finalItemImg}" class="w-100 h-100 object-fit-cover hover-scale" alt="${item.name}"
                                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'">
                                            <div class="food-type-box veg" style="position: absolute; top: 12px; right: 12px; z-index: 2;"></div>
                                        </div>
                                        <div class="p-3">
                                            <div class="d-flex justify-content-between align-items-start mb-1">
                                                <h6 class="fw-bold mb-0 text-truncate" style="max-width: 70%;">${item.name}</h6>
                                                <span class="text-success fw-bold small">₹${item.offerPrice != null ? item.offerPrice : item.price}</span>
                                            </div>
                                            <p class="text-muted x-small mb-3 text-truncate"><i class="fas fa-utensils me-1"></i> ${item.restaurant.name}</p>
                                            <button class="btn btn-outline-zomato w-100 py-1 small add-to-cart-btn"
                                                    data-item-id="${item.id}"
                                                    data-item-name="${item.name}"
                                                    data-item-price="${item.offerPrice != null ? item.offerPrice : item.price}">
                                                + ADD
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- NON-VEG Group -->
                <c:set var="hasNonVeg" value="false" />
                <c:forEach items="${matchingItems}" var="item">
                    <c:if test="${item.foodType == 'NON_VEG'}"><c:set var="hasNonVeg" value="true" /></c:if>
                </c:forEach>

                <c:if test="${hasNonVeg}">
                    <h5 class="fw-bold mb-3 text-danger d-flex align-items-center">
                        <span class="non-veg-icon me-2"></span> Non-Vegetarian ${searchTerm}
                    </h5>
                    <div class="row g-4 mb-4">
                        <c:forEach items="${matchingItems}" var="item">
                            <c:if test="${item.foodType == 'NON_VEG'}">
                                <div class="col-md-3">
                                    <div class="featured-item-card h-100 shadow-sm border-0 rounded-4 overflow-hidden bg-white">
                                        <div class="item-img-wrap" style="height: 180px; position: relative;">
                                            <c:set var="finalItemImg" value="${item.imageUrl}" />
                                            <c:if test="${not empty item.imageUrl && item.imageUrl.startsWith('/')}">
                                                <c:set var="finalItemImg" value="${pageContext.request.contextPath}${item.imageUrl}" />
                                            </c:if>
                                            <img src="${finalItemImg}" class="w-100 h-100 object-fit-cover hover-scale" alt="${item.name}"
                                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'">
                                            <div class="food-type-box nonveg" style="position: absolute; top: 12px; right: 12px; z-index: 2;"></div>
                                        </div>
                                        <div class="p-3">
                                            <div class="d-flex justify-content-between align-items-start mb-1">
                                                <h6 class="fw-bold mb-0 text-truncate" style="max-width: 70%;">${item.name}</h6>
                                                <span class="text-success fw-bold small">₹${item.offerPrice != null ? item.offerPrice : item.price}</span>
                                            </div>
                                            <p class="text-muted x-small mb-3 text-truncate"><i class="fas fa-utensils me-1"></i> ${item.restaurant.name}</p>
                                            <button class="btn btn-outline-zomato w-100 py-1 small add-to-cart-btn"
                                                    data-item-id="${item.id}"
                                                    data-item-name="${item.name}"
                                                    data-item-price="${item.offerPrice != null ? item.offerPrice : item.price}">
                                                + ADD
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <hr class="mt-5 mb-5 opacity-10">
                <h3 class="fw-bold fs-3 mb-4">Matching Restaurants</h3>
            </div>
        </c:if>

        <c:forEach items="${restaurants}" var="res">
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/restaurants/${res.id}" class="text-decoration-none text-dark">
                    <div class="res-card-list animate-fade-up">
                        <div class="res-img-wrapper mb-3 text-white">
                            <c:set var="finalResImg" value="${res.imageUrl}" />
                            <c:if test="${not empty res.imageUrl && res.imageUrl.startsWith('/')}">
                                <c:set var="finalResImg" value="${pageContext.request.contextPath}${res.imageUrl}" />
                            </c:if>
                            <img src="${finalResImg}" alt="${res.name}" class="hover-scale">
                            <div class="res-offer">50% OFF up to ₹100</div>
                        </div>
                        <div class="d-flex justify-content-between align-items-start mb-1">
                            <h4 class="fw-bold fs-5 m-0 text-truncate" style="max-width: 80%;">${res.name}</h4>
                            <span class="rating-badge small">${res.rating} <i class="fas fa-star" style="font-size: 8px;"></i></span>
                        </div>
                        <div class="d-flex justify-content-between text-zomato-gray small mb-3">
                            <span class="text-truncate" style="max-width: 60%;">Biryani, North Indian, Mughlai</span>
                            <span class="fw-medium text-dark opacity-75">₹${res.rating * 100 + 100} for one</span>
                        </div>
                        <div class="text-zomato-gray small border-top pt-3 d-flex align-items-center opacity-75">
                            <i class="fas fa-map-marker-alt me-2 text-zomato-red"></i> 
                            <span class="text-truncate">${res.address}</span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- Zomato Gold Promotional Section -->
    <div class="my-5 p-5 rounded-4 animate-fade-up shadow-lg overflow-hidden position-relative" style="background: linear-gradient(135deg, #1c1c1c 0%, #3e3e3e 100%);">
        <div class="position-absolute top-0 end-0 p-4 opacity-10">
            <i class="fas fa-crown" style="font-size: 15rem; color: #ffca28; transform: rotate(15deg);"></i>
        </div>
        <div class="row align-items-center position-relative" style="z-index: 2;">
            <div class="col-md-8">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="badge bg-warning text-dark fw-bold px-3 py-2 rounded-pill shadow-sm">ZOMATO GOLD</span>
                </div>
                <h2 class="fw-bold mb-3 text-white" style="font-size: 2.5rem;">The Most Powerful <span style="color: #ffca28;">Membership</span></h2>
                <p class="fs-5 text-white opacity-75 mb-4">Unlimited free delivery, extra discounts, and exclusive dining privileges at 20,000+ top restaurants.</p>
                <div class="d-flex gap-3">
                    <button class="btn btn-warning fw-bold px-5 py-3 rounded-pill shadow">Join Gold for ₹99</button>
                    <button class="btn btn-outline-light px-4 py-3 rounded-pill">Learn More</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Dining & Nightlife Inspiration -->
    <div class="row g-4 mb-5 animate-fade-up">
        <div class="col-md-6 text-white">
            <div class="rounded-4 overflow-hidden position-relative shadow" style="height: 320px;">
                <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80" class="w-100 h-100 object-fit-cover shadow" alt="Dining">
                <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(0,0,0,0.8));">
                    <h3 class="fw-bold mb-1">Premium Dining</h3>
                    <p class="mb-0 opacity-80">Experience the world's finest cuisines with prime seating</p>
                </div>
            </div>
        </div>
        <div class="col-md-6 text-white">
            <div class="rounded-4 overflow-hidden position-relative shadow" style="height: 320px;">
                <img src="https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80" class="w-100 h-100 object-fit-cover" alt="Nightlife">
                <div class="position-absolute bottom-0 start-0 w-100 p-4" style="background: linear-gradient(transparent, rgba(0,0,0,0.8));">
                    <h3 class="fw-bold mb-1">Ultimate Nightlife</h3>
                    <p class="mb-0 opacity-80">Discover the best bars, clubs, and parties in the city</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ── Cart Toast ─────────────────────────────────────────────────────────── -->
<div class="cart-toast-custom" id="cartToastList">
    <i class="fas fa-check-circle text-success fs-5"></i>
    <span id="toastMsg">Item added to cart!</span>
    <a href="${pageContext.request.contextPath}/cart" class="btn btn-sm btn-light ms-2 fw-bold px-3 rounded-pill text-dark">View Cart</a>
</div>

<!-- ── Floating Cart Bar ──────────────────────────────────────────────────── -->
<div class="floating-cart-bar" id="floatingCartBar">
    <div class="d-flex align-items-center gap-2">
        <i class="fas fa-shopping-bag fs-5"></i>
        <div>
            <span id="cartCount">0</span> Items | <span class="fw-bold">₹<span id="cartTotal">0</span></span>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/cart" class="text-white text-decoration-none fw-bold d-flex align-items-center gap-2">
        View Cart <i class="fas fa-chevron-right small"></i>
    </a>
</div>

<jsp:include page="common/footer.jsp" />

<script>
document.addEventListener('DOMContentLoaded', function () {
    
    // Initial cart load
    updateFloatingBar();

    document.body.addEventListener('click', function (e) {
        const btn = e.target.closest('.add-to-cart-btn');
        if (!btn) return;

        const itemId   = btn.getAttribute('data-item-id');
        const itemName = btn.getAttribute('data-item-name');
        const itemPrice = btn.getAttribute('data-item-price');

        // Optimistic button feedback
        const origText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>...';

        const formData = new URLSearchParams();
        formData.append('menuItemId', itemId);
        formData.append('quantity', 1);

        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            body: formData,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(r => r.text())
        .then(data => {
            if (data === 'REDIRECT_LOGIN') {
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            if (data === 'SUCCESS') {
                btn.innerHTML = '<i class="fas fa-check me-1"></i>';
                btn.classList.add('btn-success-feedback');
                btn.style.color = '#fff';

                // Show toast
                const toast = document.getElementById('cartToastList');
                document.getElementById('toastMsg').textContent = (itemName || 'Item') + ' added!';
                toast.classList.add('show');
                
                // Update floating bar
                updateFloatingBar();

                setTimeout(() => {
                    btn.disabled = false;
                    btn.innerHTML = origText;
                    btn.classList.remove('btn-success-feedback');
                    btn.style.color = '';
                }, 1800);

                setTimeout(() => toast.classList.remove('show'), 4000);
            }
        })
        .catch(() => {
            btn.disabled = false;
            btn.innerHTML = origText;
        });
    });

    function updateFloatingBar() {
        fetch('${pageContext.request.contextPath}/cart/summary')
            .then(r => r.json())
            .then(data => {
                const bar = document.getElementById('floatingCartBar');
                if (data.count > 0) {
                    document.getElementById('cartCount').textContent = data.count;
                    document.getElementById('cartTotal').textContent = data.total;
                    bar.classList.add('show');
                } else {
                    bar.classList.remove('show');
                }
            });
    }
});
</script>
</body>
</html>
