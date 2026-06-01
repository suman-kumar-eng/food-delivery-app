<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="main-header">
    <div class="container d-flex align-items-center justify-content-between">
        <a class="navbar-brand py-0" href="${pageContext.request.contextPath}/">
            <span class="text-zomato-red okra-font fs-1" style="font-size: 36px !important;">zomato</span>
        </a>
        
        <div class="header-search flex-grow-1 mx-5 d-none d-lg-block">
            <div class="input-group border rounded-4 p-0 shadow-sm overflow-hidden glass-panel" style="height: 54px;">
                <div class="d-flex align-items-center px-3 bg-white" style="width: 220px; border-right: 1px solid var(--zomato-border);">
                    <i class="fas fa-map-marker-alt text-zomato-red me-2 fs-5 detect-location-btn" style="cursor: pointer;" title="Detect current location"></i>
                    <select id="location-select-header" class="border-0 fw-medium bg-transparent flex-grow-1" style="outline:none; cursor: pointer;">
                        <option value="Hyderabad" selected>Hyderabad</option>
                        <option value="Mumbai">Mumbai</option>
                        <option value="Delhi">Delhi</option>
                        <option value="Bangalore">Bangalore</option>
                        <option value="Pune">Pune</option>
                        <option value="Chennai">Chennai</option>
                    </select>
                </div>
                <div class="d-flex align-items-center px-3 bg-white flex-grow-1">
                    <i class="fas fa-search text-muted me-3 fs-5"></i>
                    <form action="${pageContext.request.contextPath}/restaurants" method="GET" class="w-100 m-0">
                        <input type="text" name="search" class="border-0 w-100 bg-transparent" placeholder="Search for restaurant, cuisine or a dish" style="outline:none; height: 100%;">
                    </form>
                </div>
            </div>
        </div>

        <div class="d-flex align-items-center gap-3">
            <div id="current-datetime" class="text-muted small fw-medium d-none d-xl-flex align-items-center gap-2 bg-light px-3 py-2 rounded-pill">
                <i class="far fa-calendar-alt text-zomato-red"></i>
                <span id="date-display"></span>
                <span class="text-silver mx-1">|</span>
                <i class="far fa-clock text-zomato-red"></i>
                <span id="time-display"></span>
            </div>

            <ul class="nav align-items-center gap-3">
            <c:if test="${not empty sessionScope.loggedInUser && sessionScope.loggedInUser.role == 'ADMIN'}">
                <li class="nav-item d-none d-md-block">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-zomato py-2 px-4 rounded-pill fw-bold" style="font-size: 13px;">
                        <i class="fas fa-user-shield me-2"></i>Admin Panel
                    </a>
                </li>
            </c:if>
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <li class="nav-item">
                        <a class="nav-link text-muted fw-light position-relative" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart fs-5"></i>
                            <c:if test="${not empty cartCount && cartCount > 0}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">${cartCount}</span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-dark fw-medium d-flex align-items-center p-0" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.firstName}+${sessionScope.loggedInUser.lastName}&background=E23744&color=fff" class="rounded-circle me-2" width="36" height="36">
                            <span class="d-none d-sm-inline">${sessionScope.loggedInUser.firstName}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 p-2 mt-3">
                            <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/customer/profile">Profile</a></li>
                            <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 rounded-3 fw-bold text-danger" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a></li>
                            </c:if>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 rounded-3" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                        </ul>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="nav-item"><a class="nav-link text-zomato-gray fw-light fs-5" href="${pageContext.request.contextPath}/login">Log in</a></li>
                    <li class="nav-item"><a class="nav-link text-zomato-gray fw-light fs-5" href="${pageContext.request.contextPath}/register">Sign up</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</header>

<script>
function updateDateTime() {
    const now = new Date();
    const optionsDate = { weekday: 'short', month: 'short', day: 'numeric' };
    const optionsTime = { hour: '2-digit', minute: '2-digit', hour12: true };
    
    document.getElementById('date-display').textContent = now.toLocaleDateString('en-US', optionsDate);
    document.getElementById('time-display').textContent = now.toLocaleTimeString('en-US', optionsTime);
}

document.addEventListener('DOMContentLoaded', () => {
    updateDateTime();
    setInterval(updateDateTime, 10000); // Update every 10 seconds

    // Location Detection Logic
    const locationBtns = document.querySelectorAll('.detect-location-btn');
    locationBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const icon = this;
            const selectId = icon.id === 'detect-hero' ? 'location-select-hero' : 'location-select-header';
            const selectEl = document.getElementById(selectId);
            
            if (!selectEl) return;
            
            icon.classList.add('fa-spin', 'text-primary');
            icon.classList.remove('text-zomato-red', 'text-danger');

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((position) => {
                    // Simulating a high-end reverse geocoding experience
                    setTimeout(() => {
                        const locations = ["Hitech City, Hyderabad", "Jubilee Hills, Hyderabad", "Banjara Hills, Hyderabad"];
                        const randomLoc = locations[Math.floor(Math.random() * locations.length)];
                        
                        // Check if option already exists
                        let exists = false;
                        for(let i=0; i<selectEl.options.length; i++){
                            if(selectEl.options[i].value === randomLoc){
                                exists = true;
                                selectEl.selectedIndex = i;
                                break;
                            }
                        }
                        
                        if(!exists){
                            const newOpt = new Option(randomLoc, randomLoc, true, true);
                            selectEl.add(newOpt);
                        }
                        
                        icon.classList.remove('fa-spin', 'text-primary');
                        icon.classList.add('text-success');
                        setTimeout(() => icon.classList.remove('text-success'), 2000);
                        if(selectId === 'location-select-header') {
                             icon.classList.add('text-zomato-red');
                        } else {
                             icon.classList.add('text-danger');
                        }
                    }, 1500);
                }, (error) => {
                    icon.classList.remove('fa-spin', 'text-primary');
                    icon.classList.add('text-zomato-red');
                    alert("Location access denied. Please enable it in your browser.");
                });
            } else {
                alert("Geolocation is not supported by your browser.");
                icon.classList.remove('fa-spin', 'text-primary');
            }
        });
    });
});
</script>
