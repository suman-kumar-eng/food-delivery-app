<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zomato - Best Food in Hyderabad</title>
    <meta name="description" content="Order food online from the best restaurants in Hyderabad. Fast delivery, great taste.">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/static/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        /* ── Hero ─────────────────────────────────────── */
        .hero-banner {
            background: linear-gradient(rgba(0,0,0,0.52), rgba(0,0,0,0.62)),
                        url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80') center/cover;
            height: 480px;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            color: white; text-shadow: 0 4px 10px rgba(0,0,0,0.4);
        }
        .hero-logo-large { font-size: 96px; font-weight: 900; letter-spacing: -5px; }
        .hero-subtext { font-size: 36px; font-weight: 400; margin-top: -16px; margin-bottom: 38px; }
        .search-inner { border-radius: 12px; height: 56px; box-shadow: 0 4px 18px rgba(0,0,0,0.15); }

        /* ── Collections ───────────────────────────────── */
        .collection-card { position: relative; height: 300px; border-radius: 12px; overflow: hidden; }
        .collection-card img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s; }
        .collection-card:hover img { transform: scale(1.05); }
        .collection-overlay { position: absolute; bottom: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(transparent 40%, rgba(0,0,0,0.85)); display: flex; flex-direction: column; justify-content: flex-end; padding: 20px; color: white; }

        /* ── Featured Items ────────────────────────────── */
        .featured-item-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--zomato-border);
            overflow: hidden;
            transition: box-shadow 0.25s, transform 0.25s;
            cursor: pointer;
        }
        .featured-item-card:hover { box-shadow: 0 8px 28px rgba(0,0,0,0.12); transform: translateY(-4px); }
        
        .item-img-wrap { position: relative; overflow: hidden; height: 200px; }
        .item-img-wrap img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .featured-item-card:hover .item-img-wrap img { transform: scale(1.08); }

        /* Veg / Non-veg indicator box */
        .food-type-box {
            position: absolute; top: 10px; left: 10px;
            width: 20px; height: 20px; border-radius: 4px;
            border: 2px solid; display: flex; align-items: center; justify-content: center;
        }
        .food-type-box.veg { border-color: #48c479; background: white; }
        .food-type-box.veg::after { content: ''; width: 8px; height: 8px; border-radius: 50%; background: #48c479; }
        .food-type-box.nonveg { border-color: #e44; background: white; }
        .food-type-box.nonveg::after { content: ''; width: 8px; height: 8px; border-radius: 50%; background: #e44; }

        /* ADD TO CART button */
        .item-add-overlay {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 10px;
            background: linear-gradient(transparent, rgba(0,0,0,0.5));
            display: flex; justify-content: center;
            transform: translateY(100%); transition: transform 0.3s ease;
        }
        .featured-item-card:hover .item-add-overlay { transform: translateY(0); }
        .btn-add-hover {
            background: white; color: var(--zomato-red);
            font-weight: 700; font-size: 14px; letter-spacing: 0.5px;
            border: none; border-radius: 8px;
            padding: 8px 36px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: background 0.2s;
        }
        .btn-add-hover:hover { background: #fff5f5; }

        /* Price styling */
        .price-main { font-weight: 700; font-size: 16px; color: #222; }
        .price-offer { color: var(--zomato-red); font-size: 13px; font-weight: 600; }
        .price-strike { text-decoration: line-through; color: #999; font-size: 12px; }

        /* Bestseller badge */
        .bestseller-tag { 
            position: absolute; top: 10px; right: 10px;
            background: linear-gradient(135deg, #f7971e, #ffd200);
            color: #333; font-size: 10px; font-weight: 700;
            padding: 3px 10px; border-radius: 50px;
            letter-spacing: 0.5px;
        }

        /* Dining type cards */
        .dining-type-card { border-radius: 14px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid var(--zomato-border); transition: 0.25s; }
        .dining-type-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.1); }

        /* Toast notification */
        .cart-toast-custom {
            position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%);
            background: #222; color: white;
            padding: 14px 28px; border-radius: 50px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.25);
            z-index: 9999; font-size: 15px; font-weight: 500;
            display: flex; align-items: center; gap: 14px;
            opacity: 0; transition: opacity 0.35s; pointer-events: none;
            white-space: nowrap;
        }
        .cart-toast-custom.show { opacity: 1; pointer-events: auto; }

        /* Floating Cart Bar */
        .floating-cart-bar {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            max-width: 600px;
            background: #2D926D;
            color: white;
            padding: 12px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            z-index: 1000;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            opacity: 0;
            pointer-events: none;
        }
        .floating-cart-bar.show {
            opacity: 1;
            pointer-events: auto;
            bottom: 30px;
        }

        /* Filter Chips */
        .filter-chip {
            padding: 8px 16px; border: 1.5px solid var(--zomato-border);
            border-radius: 8px; background: white; color: var(--zomato-gray);
            font-size: 14px; font-weight: 500; cursor: pointer; transition: 0.2s;
            display: flex; align-items: center; justify-content: center;
        }
        .filter-chip:hover { border-color: var(--zomato-gray); background: var(--zomato-bg); }
        .filter-chip.active { border-color: var(--zomato-red); color: var(--zomato-red); background: #fcecec; }
    </style>
</head>
<body class="bg-white">

<jsp:include page="common/header.jsp" />

<!-- ── Hero Section ──────────────────────────────────────────────────────── -->
<div class="hero-banner animate-fade-up">
    <div class="hero-logo-large okra-font floating">zomato</div>
    <div class="hero-subtext">Discover the best food &amp; drinks in Hyderabad</div>

    <div class="container" style="max-width: 850px;">
        <div class="bg-white search-inner d-flex align-items-center p-0 overflow-hidden">
            <div class="flex-shrink-0 px-4 py-2 border-end d-flex align-items-center bg-white" style="min-width: 210px; cursor: pointer;">
                <i id="detect-hero" class="fas fa-map-marker-alt text-danger me-2 fs-5 detect-location-btn" title="Detect current location"></i>
                <select id="location-select-hero" class="border-0 fw-medium flex-grow-1" style="outline:none; cursor: pointer;">
                    <option value="Hyderabad" selected>Hyderabad</option>
                    <option value="Mumbai">Mumbai</option>
                    <option value="Delhi">Delhi</option>
                    <option value="Bangalore">Bangalore</option>
                    <option value="Pune">Pune</option>
                    <option value="Chennai">Chennai</option>
                </select>
            </div>
            <div class="flex-grow-1 px-4 d-flex align-items-center bg-white">
                <i class="fas fa-search text-muted me-3 fs-5"></i>
                <form action="${pageContext.request.contextPath}/restaurants" method="GET" class="w-100 m-0">
                    <input type="text" name="search" class="border-0 w-100"
                           style="outline:none; font-size:16px; padding: 15px 0;" placeholder="Search for restaurant, cuisine or a dish">
                </form>
            </div>
        </div>
    </div>
</div>

<div class="container my-5 pb-5">

    <!-- ── Inspiration Section (Real Zomato Feature) ───────────────────────── -->
    <div class="mb-5 animate-fade-up" style="animation-delay: 0.1s;">
        <h2 class="fw-bold mb-4">Inspiration for your first order</h2>
        <div class="d-flex justify-content-between text-center overflow-auto pb-3 hide-scrollbar">
            <a href="${pageContext.request.contextPath}/restaurants?search=Biryani" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="${pageContext.request.contextPath}/static/images/biryani.png" class="w-100 h-100 object-fit-cover" alt="Biryani">
                </div>
                <h6 class="fw-medium text-dark">Biryani</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Pizza" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Pizza</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Thali" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Thali</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Burger" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Burger</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Chicken" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Chicken</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Cake" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Cake</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Ice Cream" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1501443762994-82bd5dabb892?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Ice Cream</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=North Indian" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">North Indian</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Rolls" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1626700051175-6818013e1d4f?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Rolls</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Coffee" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Coffee</h6>
            </a>
            <a href="${pageContext.request.contextPath}/restaurants?search=Sweets" class="text-decoration-none mx-3" style="min-width: 150px;">
                <div class="rounded-circle overflow-hidden mb-2 shadow-sm hover-scale" style="width: 150px; height: 150px;">
                    <img src="https://images.unsplash.com/photo-1589119908995-c6837fa14848?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" class="w-100 h-100 object-fit-cover">
                </div>
                <h6 class="fw-medium text-dark">Sweets</h6>
            </a>
        </div>
    </div>

    <!-- ── Dining Types ──────────────────────────────────────────────────── -->
    <div class="row g-4 mb-5 animate-fade-up" style="animation-delay: 0.2s;">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/restaurants" class="text-decoration-none">
                <div class="dining-type-card">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"
                         class="w-100" style="height:180px; object-fit:cover;">
                    <div class="p-3 bg-white">
                        <h5 class="mb-1 fw-bold">Order Online</h5>
                        <p class="text-muted small mb-0">Stay home and order to your doorstep</p>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/restaurants" class="text-decoration-none">
                <div class="dining-type-card shadow-sm border-0">
                    <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"
                         class="w-100" style="height:180px; object-fit:cover;">
                    <div class="p-3 bg-white">
                        <h5 class="mb-1 fw-bold text-dark">Dining Out</h5>
                        <p class="text-muted small mb-0">View the city's favourite dining venues</p>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/restaurants?search=Mughlai" class="text-decoration-none">
                <div class="dining-type-card shadow-sm border-0">
                    <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"
                         class="w-100" style="height:180px; object-fit:cover;">
                    <div class="p-3 bg-white">
                        <h5 class="mb-1 fw-bold text-dark">Zomato Pro</h5>
                        <p class="text-muted small mb-0">Enjoy exclusive dining rewards</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- ── Collections ───────────────────────────────────────────────────── -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h2 class="mb-1 fw-bold">Collections</h2>
            <p class="text-muted mb-0">Explore curated lists of top restaurants in Hyderabad</p>
        </div>
        <a href="#" class="text-zomato-red text-decoration-none fw-medium">All collections <i class="fas fa-caret-right"></i></a>
    </div>

    <div class="row mb-5 g-4">
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

    <!-- ── Featured Items (dynamically from DB) ──────────────────────────── -->
    <c:if test="${not empty featuredItems}">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="mb-1 fw-bold">🔥 Available Items</h2>
                <p class="text-muted mb-0">Add directly to cart — fresh items from our restaurants</p>
            </div>
            <a href="${pageContext.request.contextPath}/restaurants" class="text-zomato-red text-decoration-none fw-medium">
                Browse all <i class="fas fa-caret-right"></i>
            </a>
        </div>

        <!-- Veg/Non-Veg Filter -->
        <div class="d-flex gap-2 mb-4">
            <button class="filter-chip active" id="filterAll">All</button>
            <button class="filter-chip" id="filterVeg"><span class="veg-icon me-1"></span> Veg Only</button>
            <button class="filter-chip" id="filterNonVeg"><span class="non-veg-icon me-1"></span> Non-Veg</button>
        </div>

        <div class="row g-4 mb-5">
            <c:forEach items="${featuredItems}" var="item" varStatus="loop">
                <div class="col-sm-6 col-md-4 col-lg-3">
                    <div class="featured-item-card h-100">

                        <!-- Image -->
                        <div class="item-img-wrap">
                            <c:set var="finalImageUrl" value="${item.imageUrl}" />
                            <c:if test="${not empty item.imageUrl && item.imageUrl.startsWith('/')}">
                                <c:set var="finalImageUrl" value="${pageContext.request.contextPath}${item.imageUrl}" />
                            </c:if>
                            <img src="${finalImageUrl}" alt="${item.name}"
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'">

                            <!-- VEG / NON-VEG dot -->
                            <div class="food-type-box ${item.foodType == 'VEG' ? 'veg' : 'nonveg'}"></div>

                            <!-- Bestseller -->
                            <c:if test="${item.id % 3 == 0}">
                                <div class="bestseller-tag"><i class="fas fa-star me-1"></i>BESTSELLER</div>
                            </c:if>

                            <!-- ADD button slides up on hover -->
                            <div class="item-add-overlay">
                                <button class="btn-add-hover add-to-cart-btn"
                                        data-item-id="${item.id}"
                                        data-item-name="${item.name}"
                                        data-item-price="${item.offerPrice != null ? item.offerPrice : item.price}">
                                    + ADD
                                </button>
                            </div>
                        </div>

                        <!-- Info -->
                        <div class="p-3">
                            <div class="fw-bold mb-1 text-truncate" title="${item.name}">${item.name}</div>
                            <div class="text-muted small mb-2 text-truncate">${item.restaurant.name}</div>

                            <!-- Pricing -->
                            <div class="d-flex align-items-center gap-2">
                                <c:choose>
                                    <c:when test="${item.offerPrice != null}">
                                        <span class="price-offer">₹${item.offerPrice}</span>
                                        <span class="price-strike">₹${item.price}</span>
                                        <span class="badge bg-success-subtle text-success ms-auto" style="font-size:10px;">
                                            SAVE ₹<fmt:formatNumber value="${item.price - item.offerPrice}" maxFractionDigits="0"/>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-main">₹${item.price}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Visible ADD button at bottom -->
                        <div class="px-3 pb-3">
                            <button class="btn w-100 add-to-cart-btn fw-bold"
                                    style="border: 1.5px solid var(--zomato-red); color: var(--zomato-red); border-radius: 8px; padding: 7px 0; background: white; font-size: 14px; letter-spacing: 0.5px; transition: 0.2s;"
                                    data-item-id="${item.id}"
                                    data-item-name="${item.name}"
                                    data-item-price="${item.offerPrice != null ? item.offerPrice : item.price}"
                                    onmouseover="this.style.background='#FFF1F2'"
                                    onmouseout="this.style.background='white'">
                                <i class="fas fa-shopping-cart me-1"></i> ADD TO CART
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- ── Restaurant Listing ─────────────────────────────────────────────── -->
    <h2 class="mb-2 fw-bold">Order Online in Hyderabad</h2>
    <p class="text-muted mb-4">Restaurants near you</p>
    <div class="row g-4">
        <c:forEach items="${restaurants}" var="res">
            <div class="col-md-4 mb-2">
                <div class="zomato-card">
                    <a href="${pageContext.request.contextPath}/restaurants/${res.id}" class="text-decoration-none text-dark">
                        <div class="position-relative">
                            <img src="${res.imageUrl}" class="w-100" style="height:240px; object-fit:cover;"
                                 alt="${res.name}"
                                 onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'">
                            <span class="position-absolute bottom-0 start-0 m-2 badge" style="background:var(--zomato-red);">FREE DELIVERY</span>
                            <span class="position-absolute top-0 end-0 m-2 badge bg-white text-dark shadow-sm">30 min</span>
                        </div>
                        <div class="p-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <h5 class="mb-0 text-truncate" style="max-width:220px;">${res.name}</h5>
                                <span class="rating-badge">${res.rating} <i class="fas fa-star" style="font-size:10px;"></i></span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mt-1">
                                <span class="text-truncate" style="max-width:180px;">${res.description}</span>
                                <span>₹250 for one</span>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ── Cart Toast ─────────────────────────────────────────────────────────── -->
<div class="cart-toast-custom" id="cartToastHome">
    <i class="fas fa-check-circle text-success fs-5"></i>
    <span id="toastMsg">Item added to cart!</span>
    <a href="${pageContext.request.contextPath}/cart" class="btn btn-sm btn-light ms-2 fw-bold px-3 rounded-pill">View Cart</a>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ── Add to Cart from home page ─────────────────────────────────────────────
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
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Adding...';

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
                btn.innerHTML = '<i class="fas fa-check me-1"></i> Added!';
                btn.style.background = '#e8f5e9';
                btn.style.borderColor = '#48c479';
                btn.style.color = '#2e7d32';

                // Show toast
                const toast = document.getElementById('cartToastHome');
                document.getElementById('toastMsg').textContent =
                    (itemName || 'Item') + ' added! ₹' + itemPrice;
                toast.classList.add('show');
                
                // Update floating bar
                updateFloatingBar();

                setTimeout(() => {
                    btn.disabled = false;
                    btn.innerHTML = origText;
                    btn.style.background = 'white';
                    btn.style.borderColor = 'var(--zomato-red)';
                    btn.style.color = 'var(--zomato-red)';
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

    // ── Veg/Non-Veg Filtering ─────────────────────────────────────────────
    const chips = document.querySelectorAll('.filter-chip');
    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            chips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            
            const filterType = chip.id; // filterAll, filterVeg, filterNonVeg
            const cards = document.querySelectorAll('.col-sm-6.col-md-4.col-lg-3');
            
            cards.forEach(card => {
                const typeBox = card.querySelector('.food-type-box');
                const isVeg = typeBox.classList.contains('veg');
                
                if (filterType === 'filterAll') {
                    card.classList.remove('d-none');
                } else if (filterType === 'filterVeg') {
                    isVeg ? card.classList.remove('d-none') : card.classList.add('d-none');
                } else if (filterType === 'filterNonVeg') {
                    !isVeg ? card.classList.remove('d-none') : card.classList.add('d-none');
                }
            });
        });
    });
});
</script>
</body>
</html>
