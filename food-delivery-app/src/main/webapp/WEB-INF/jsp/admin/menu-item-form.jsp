<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${menuItem.id != null ? 'Edit' : 'Add'} Menu Item - Zomato Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .sidebar-link { border-radius: 10px; padding: 12px 15px; text-decoration: none; color: var(--zomato-gray); display: flex; align-items: center; gap: 12px; margin-bottom: 5px; font-weight: 500; }
        .sidebar-link:hover { background: var(--zomato-bg); color: var(--zomato-red); }
        .sidebar-link.active { background: var(--zomato-red); color: white; }

        /* === Image Preview Panel === */
        .img-preview-panel {
            position: sticky;
            top: 90px;
        }
        .img-preview-wrap {
            position: relative;
            width: 100%;
            aspect-ratio: 4/3;
            border-radius: 16px;
            overflow: hidden;
            background: #f0f0f0;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .img-preview-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: opacity 0.4s ease;
        }
        .img-preview-wrap .overlay-badge {
            position: absolute;
            bottom: 12px;
            left: 12px;
            background: rgba(0,0,0,0.6);
            color: white;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
        }
        .img-preview-wrap .img-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #ccc;
        }
        .img-preview-wrap .img-placeholder i { font-size: 56px; margin-bottom: 10px; }

        /* === Suggested Images Carousel === */
        .suggest-label { font-size: 12px; color: var(--zomato-gray); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .img-suggestion-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 10px; }
        .img-suggestion-thumb {
            aspect-ratio: 1;
            border-radius: 10px;
            overflow: hidden;
            cursor: pointer;
            border: 2px solid transparent;
            transition: 0.2s;
        }
        .img-suggestion-thumb:hover, .img-suggestion-thumb.selected { border-color: var(--zomato-red); transform: scale(1.04); }
        .img-suggestion-thumb img { width: 100%; height: 100%; object-fit: cover; }

        /* === Form Card === */
        .form-card { background: white; border-radius: 16px; padding: 32px; border: 1px solid var(--zomato-border); box-shadow: 0 2px 12px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; font-size: 13px; color: #444; }
        .form-control, .form-select { border-radius: 10px; padding: 11px 14px; border-color: var(--zomato-border); font-size: 14px; }
        .form-control:focus, .form-select:focus { border-color: var(--zomato-red); box-shadow: 0 0 0 3px rgba(226,55,68,0.1); }

        /* Food type toggle */
        .food-type-toggle { display: flex; gap: 12px; }
        .food-type-btn {
            flex: 1; padding: 12px; border: 2px solid var(--zomato-border);
            border-radius: 12px; cursor: pointer; text-align: center;
            font-weight: 600; font-size: 14px; transition: 0.2s; background: white;
        }
        .food-type-btn.veg { border-color: #48c479; }
        .food-type-btn.veg.selected { background: #48c479; color: white; }
        .food-type-btn.nonveg { border-color: #e44; }
        .food-type-btn.nonveg.selected { background: #e44; color: white; }
        input[name="foodType"] { display: none; }

        /* Pulse animation on image load */
        @keyframes pulseIn {
            0% { transform: scale(1.06); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }
        .img-loaded { animation: pulseIn 0.4s ease; }
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
            <div class="d-flex align-items-center gap-3 mb-4">
                <a href="${pageContext.request.contextPath}/admin/menu-items" class="btn btn-light border rounded-3">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <div>
                    <h1 class="fw-bold m-0">
                        ${menuItem.id != null ? 'Edit Menu Item' : 'Add New Menu Item'}
                    </h1>
                    <p class="text-muted small mt-1 mb-0">Fill in details and preview the image in real-time</p>
                </div>
            </div>

            <div class="row g-4">
                <!-- LEFT: Form -->
                <div class="col-lg-7">
                    <div class="form-card">
                        <form id="menuItemForm" action="${pageContext.request.contextPath}/admin/menu-items/save" method="POST" enctype="multipart/form-data">
                            <c:if test="${menuItem.id != null}">
                                <input type="hidden" name="menuItemId" value="${menuItem.id}">
                            </c:if>

                            <!-- Name -->
                            <div class="mb-4">
                                <label class="form-label">Item Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" id="itemName" class="form-control"
                                       placeholder="e.g. Butter Chicken" value="${menuItem.name}" required>
                            </div>

                            <!-- Description -->
                            <div class="mb-4">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="3"
                                          placeholder="Describe the dish briefly...">${menuItem.description}</textarea>
                            </div>

                            <!-- Price & Offer Price -->
                            <div class="row g-3 mb-4">
                                <div class="col-6">
                                    <label class="form-label">Price (₹) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0">₹</span>
                                        <input type="number" name="price" class="form-control border-start-0"
                                               placeholder="299" step="0.01" value="${menuItem.price}" required>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <label class="form-label">Offer Price (₹) <span class="text-muted fw-normal">(optional)</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-danger">₹</span>
                                        <input type="number" name="offerPrice" class="form-control border-start-0"
                                               placeholder="249" step="0.01" value="${menuItem.offerPrice}">
                                    </div>
                                </div>
                            </div>

                            <!-- Food Type Toggle -->
                            <div class="mb-4">
                                <label class="form-label">Food Type <span class="text-danger">*</span></label>
                                <input type="hidden" name="foodType" id="foodTypeInput" value="${menuItem.foodType != null ? menuItem.foodType : 'VEG'}">
                                <div class="food-type-toggle">
                                    <div class="food-type-btn veg ${menuItem.foodType == null || menuItem.foodType == 'VEG' ? 'selected' : ''}"
                                         onclick="setFoodType('VEG', this)" id="vegBtn">
                                        <span style="font-size:18px;">🟢</span>&nbsp; VEG
                                    </div>
                                    <div class="food-type-btn nonveg ${menuItem.foodType == 'NON_VEG' ? 'selected' : ''}"
                                         onclick="setFoodType('NON_VEG', this)" id="nonVegBtn">
                                        <span style="font-size:18px;">🔴</span>&nbsp; NON-VEG
                                    </div>
                                </div>
                            </div>

                            <!-- Restaurant -->
                            <div class="mb-4">
                                <label class="form-label">Restaurant <span class="text-danger">*</span></label>
                                <select name="restaurantId" class="form-select" required>
                                    <option value="">-- Select Restaurant --</option>
                                    <c:forEach items="${restaurants}" var="res">
                                        <option value="${res.id}"
                                            ${(menuItem.restaurant != null && menuItem.restaurant.id == res.id) || preselectedRestaurantId == res.id ? 'selected' : ''}>
                                            ${res.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Category -->
                            <div class="mb-4">
                                <label class="form-label">Category <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}"
                                            ${menuItem.category != null && menuItem.category.id == cat.id ? 'selected' : ''}>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Availability -->
                            <div class="mb-4">
                                <div class="form-check form-switch ps-0">
                                    <label class="form-check-label fw-bold d-block mb-2" for="availableSwitch">Item Availability</label>
                                    <div class="d-flex align-items-center gap-3 bg-light p-3 rounded-3 border">
                                        <div class="form-check form-switch m-0">
                                            <input class="form-check-input ms-0" style="width: 40px; height: 20px; cursor: pointer;" type="checkbox" name="available" id="availableSwitch" value="true" ${menuItem.available ? 'checked' : ''}>
                                        </div>
                                        <div>
                                            <span class="fw-bold small" id="stockStatusText">${menuItem.available ? 'Currently In Stock' : 'Currently Out of Stock'}</span>
                                            <p class="text-muted small m-0">Toggle this to show/hide the 'ADD' button for customers.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Food Image <span class="text-danger">*</span></label>
                                <div class="mb-3">
                                    <input type="file" name="imageFile" id="imageFileInput" class="form-control" accept="image/*" onchange="previewSelectedFile(this)">
                                </div>
                                <div class="text-center text-muted mb-2 small">OR</div>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-link text-muted"></i></span>
                                    <input type="text" name="imageUrl" id="imageUrlInput" class="form-control border-start-0"
                                           placeholder="Paste image URL here..."
                                           value="${menuItem.imageUrl}"
                                           oninput="updatePreview(this.value)">
                                </div>
                                <div class="form-text">Choose a file from your computer or paste an image URL.</div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-3 mt-4">
                                <button type="submit" class="btn btn-zomato py-2 px-5 fw-bold">
                                    <i class="fas fa-save me-2"></i>
                                    ${menuItem.id != null ? 'Update Item' : 'Save Item'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/menu-items" class="btn btn-light border py-2 px-4">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- RIGHT: Live Image Preview -->
                <div class="col-lg-5">
                    <div class="img-preview-panel">
                        <p class="fw-bold mb-3"><i class="fas fa-eye me-2 text-zomato-red"></i>Live Preview</p>

                        <!-- Preview Box -->
                        <div class="img-preview-wrap mb-3" id="previewBox">
                            <div class="img-placeholder" id="previewPlaceholder">
                                <i class="fas fa-camera-retro"></i>
                                <span class="fw-medium small">Paste an image URL to preview</span>
                            </div>
                            <img id="previewImg" src="" alt="Preview" style="display:none;"
                                 onerror="handleImgError()" onload="handleImgLoad()">
                            <div class="overlay-badge" id="previewName" style="display:none;"></div>
                        </div>

                        <!-- Suggested Images by Category -->
                        <div class="mb-1 suggest-label"><i class="fas fa-bolt me-1 text-warning"></i>Quick Pick — Click to use</div>
                        <p class="text-muted" style="font-size:11px;">Sample food images — click any to auto-fill URL</p>
                        <div class="img-suggestion-grid" id="suggestionGrid">
                            <!-- Populated by JS -->
                        </div>

                        <!-- Card Preview -->
                        <div class="mt-4 bg-white rounded-4 border overflow-hidden shadow-sm" id="cardPreviewWrap" style="display:none;">
                            <p class="fw-bold px-3 pt-3 mb-2 small text-muted text-uppercase" style="letter-spacing:0.5px;">Card Preview</p>
                            <div style="display:flex; padding: 12px 16px; gap:14px; align-items:center; border-top: 1px solid var(--zomato-border);">
                                <img id="cardPreviewImg" src="" style="width:70px; height:70px; border-radius:10px; object-fit:cover;">
                                <div>
                                    <div class="fw-bold" id="cardPreviewName">Item Name</div>
                                    <div class="text-muted small" id="cardPreviewPrice">₹0.00</div>
                                </div>
                                <div class="ms-auto">
                                    <button class="btn btn-sm btn-outline-danger fw-bold px-3">ADD</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ── Suggested image library ──────────────────────────────────────────────────
const SUGGESTED_IMAGES = [
    { url: 'https://images.unsplash.com/photo-1574071318508-1cdbcd80ad55?w=500', label: 'Pizza' },
    { url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500', label: 'Burger' },
    { url: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500', label: 'Biryani' },
    { url: 'https://images.unsplash.com/photo-1563379091339-03b21bc4a4f8?w=500', label: 'Biryani 2' },
    { url: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500', label: 'Noodles' },
    { url: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500', label: 'Dessert' },
    { url: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500', label: 'Salad' },
    { url: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?w=500', label: 'Tikka' },
    { url: 'https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?w=500', label: 'Paneer' }
];

// ── Render suggestion thumbnails ─────────────────────────────────────────────
const grid = document.getElementById('suggestionGrid');
SUGGESTED_IMAGES.forEach((img, idx) => {
    const div = document.createElement('div');
    div.className = 'img-suggestion-thumb';
    div.id = 'thumb-' + idx;
    div.title = img.label;
    div.innerHTML = `<img src="${img.url}" alt="${img.label}" loading="lazy">`;
    div.onclick = () => pickSuggested(img.url, idx);
    grid.appendChild(div);
});

// ── Pick a suggested image ───────────────────────────────────────────────────
function pickSuggested(url, idx) {
    document.getElementById('imageUrlInput').value = url;
    document.getElementById('imageFileInput').value = ''; // Clear file input
    updatePreview(url);
    document.querySelectorAll('.img-suggestion-thumb').forEach(t => t.classList.remove('selected'));
    document.getElementById('thumb-' + idx).classList.add('selected');
}

// ── Preview selected local file ──────────────────────────────────────────────
function previewSelectedFile(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('imageUrlInput').value = ''; // Clear URL input
            updatePreview(e.target.result);
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ── Live image preview ───────────────────────────────────────────────────────
let previewTimer = null;
function updatePreview(url) {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(() => {
        if (!url || url.trim() === '') {
            showPlaceholder();
            return;
        }
        const img = document.getElementById('previewImg');
        img.style.opacity = '0';
        img.src = url.trim();
    }, 350); // debounce 350ms
}

function handleImgLoad() {
    const img = document.getElementById('previewImg');
    const placeholder = document.getElementById('previewPlaceholder');
    const nameTag = document.getElementById('previewName');
    const cardWrap = document.getElementById('cardPreviewWrap');
    const cardImg = document.getElementById('cardPreviewImg');

    placeholder.style.display = 'none';
    img.style.display = 'block';
    img.classList.remove('img-loaded');
    void img.offsetWidth; // force reflow
    img.classList.add('img-loaded');
    img.style.opacity = '1';

    // Name overlay on preview
    const name = document.getElementById('itemName').value || 'Food Item';
    nameTag.textContent = name;
    nameTag.style.display = 'block';

    // Card preview
    cardImg.src = img.src;
    document.getElementById('cardPreviewName').textContent = name;
    const priceEl = document.querySelector('input[name="price"]');
    document.getElementById('cardPreviewPrice').textContent = priceEl && priceEl.value ? '₹' + priceEl.value : '₹—';
    cardWrap.style.display = 'block';
}

function handleImgError() {
    showPlaceholder();
}

function showPlaceholder() {
    const img = document.getElementById('previewImg');
    img.style.display = 'none';
    document.getElementById('previewPlaceholder').style.display = 'flex';
    document.getElementById('previewName').style.display = 'none';
    document.getElementById('cardPreviewWrap').style.display = 'none';
}

// ── Food Type toggle ─────────────────────────────────────────────────────────
function setFoodType(type, el) {
    document.getElementById('foodTypeInput').value = type;
    document.getElementById('vegBtn').classList.remove('selected');
    document.getElementById('nonVegBtn').classList.remove('selected');
    el.classList.add('selected');
}

// ── Update card preview on name/price change ─────────────────────────────────
document.getElementById('itemName').addEventListener('input', function() {
    document.getElementById('cardPreviewName').textContent = this.value || 'Food Item';
    document.getElementById('previewName').textContent = this.value || 'Food Item';
});
document.querySelector('input[name="price"]').addEventListener('input', function() {
    document.getElementById('cardPreviewPrice').textContent = this.value ? '₹' + this.value : '₹—';
});

// ── Stock switch text update ──────────────────────────────────────────────────
document.getElementById('availableSwitch').addEventListener('change', function() {
    document.getElementById('stockStatusText').textContent = this.checked ? 'Currently In Stock' : 'Currently Out of Stock';
});

// ── Init: if editing, show existing image ────────────────────────────────────
window.addEventListener('DOMContentLoaded', () => {
    const existingUrl = document.getElementById('imageUrlInput').value;
    if (existingUrl) updatePreview(existingUrl);
});
</script>
</body>
</html>
