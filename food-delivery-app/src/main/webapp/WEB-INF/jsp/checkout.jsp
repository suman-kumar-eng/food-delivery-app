<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Zomato</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/zomato-style.css" rel="stylesheet">
    <style>
        body { background-color: var(--zomato-bg) !important; }
        .checkout-card { background: white; border-radius: 12px; padding: 25px; margin-bottom: 20px; box-shadow: 0 1px 10px rgba(0,0,0,0.05); border: 1px solid var(--zomato-border); }
        .address-box { border: 1px solid var(--zomato-border); border-radius: 10px; padding: 15px; cursor: pointer; transition: 0.2s; position: relative; }
        .address-box:hover { border-color: var(--zomato-gray); }
        .address-box.selected { border: 2px solid var(--zomato-red); background: #FFF1F2; }
        .address-box.selected::after { content: '\f058'; font-family: "Font Awesome 6 Free"; font-weight: 900; position: absolute; top: 10px; right: 10px; color: var(--zomato-red); }
        .payment-box { display: flex; align-items: center; gap: 15px; border: 1px solid var(--zomato-border); border-radius: 10px; padding: 15px; margin-bottom: 12px; cursor: pointer; transition: 0.2s; }
        .payment-box:hover { background: var(--zomato-bg); }
        .payment-box.selected { border: 2px solid var(--zomato-red); background: #FFF1F2; }
        .summary-sticky { position: sticky; top: 100px; }
    </style>
</head>
<body>

<jsp:include page="common/header.jsp" />

<div class="container py-5">
    <div class="row g-4">
        <!-- Main Form Column -->
        <div class="col-lg-8">
            <h3 class="fw-bold mb-4">Checkout</h3>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/orders/place" method="POST" id="checkoutForm">
                <!-- Select Address -->
                <div class="checkout-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold m-0"><i class="fas fa-map-marker-alt text-zomato-red me-2"></i> Select Delivery Address</h5>
                        <button type="button" class="btn btn-outline-zomato btn-sm" data-bs-toggle="modal" data-bs-target="#addAddressModal">Add New Address</button>
                    </div>

                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="row g-3">
                                <c:forEach items="${addresses}" var="addr">
                                    <div class="col-md-6">
                                        <div class="address-box h-100 select-address-btn" data-address-id="${addr.id}">
                                            <div class="fw-bold mb-1"><i class="fas fa-home me-2 text-muted"></i> Home</div>
                                            <div class="text-zomato-gray small">${addr.street}, ${addr.city}</div>
                                            <div class="text-zomato-gray small">PIN: ${addr.zipCode}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <input type="hidden" name="addressId" id="selectedAddressId" required>
                        </c:when>
                        <c:otherwise>
                            <div class="p-3 rounded-3 text-danger bg-danger-subtle small">
                                <i class="fas fa-exclamation-circle me-2"></i> No addresses found. Please add an address to continue.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Payment Methods -->
                <div class="checkout-card">
                    <h5 class="fw-bold mb-4"><i class="fas fa-wallet text-zomato-red me-2"></i> Select Payment Method</h5>
                    
                    <div class="payment-box selected select-payment-btn" data-method="COD">
                        <i class="fas fa-money-bill-wave text-success fs-4"></i>
                        <div class="flex-grow-1">
                            <div class="fw-bold">Cash on Delivery</div>
                            <div class="text-zomato-gray small">Pay at your doorstep</div>
                        </div>
                    </div>
                    
                    <div class="payment-box select-payment-btn" data-method="ONLINE">
                        <i class="fas fa-credit-card text-primary fs-4"></i>
                        <div class="flex-grow-1">
                            <div class="fw-bold">Online Payment</div>
                            <div class="text-zomato-gray small">UPI, Cards, Netbanking</div>
                        </div>
                    </div>
                    
                    <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="COD" required>
                </div>
            </form>
        </div>

        <!-- Summary Column -->
        <div class="col-lg-4">
            <div class="checkout-card summary-sticky">
                <h5 class="fw-bold mb-3">Order Summary</h5>
                <c:forEach items="${cart.items}" var="item">
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-zomato-gray">${item.quantity} x ${item.menuItem.name}</span>
                        <span>₹${item.price * item.quantity}</span>
                    </div>
                </c:forEach>
                
                <hr class="my-3" style="border-style: dotted;">
                
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-zomato-gray">Item Total</span>
                    <span>₹${total}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-zomato-gray">Taxes (5%)</span>
                    <span>₹${total * 0.05}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-zomato-gray">Delivery Charge</span>
                    <span class="text-success fw-bold">FREE</span>
                </div>
                
                <hr class="my-3">
                
                <div class="d-flex justify-content-between mb-4">
                    <h5 class="fw-bold m-0">Grand Total</h5>
                    <h5 class="fw-bold m-0 text-zomato-red">₹${total + (total * 0.05)}</h5>
                </div>
                
                <button type="button" id="placeOrderBtn" class="btn btn-zomato w-100 py-3 fs-5 shadow-sm">Place Order</button>
            </div>
            
            <div class="mt-3 px-2 text-center text-zomato-gray small">
                <i class="fas fa-shield-alt text-success me-1"></i> Safe and secure payments. 100% Authentic food.
            </div>
        </div>
    </div>
</div>

<!-- Add Address Modal -->
<div class="modal fade" id="addAddressModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <h5 class="modal-title fw-bold fs-4">Add Delivery Address</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="${pageContext.request.contextPath}/orders/checkout/add-address" method="POST">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Street / Area</label>
                        <input type="text" name="street" class="form-control form-control-lg" placeholder="e.g. 123 Main St, Apt 4B" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase">City</label>
                            <input type="text" name="city" class="form-control form-control-lg" placeholder="e.g. Hyderabad" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase">State</label>
                            <input type="text" name="state" class="form-control form-control-lg" placeholder="e.g. Telangana" required>
                        </div>
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase">PIN / Zip Code</label>
                            <input type="text" name="zipCode" class="form-control form-control-lg" placeholder="e.g. 500081" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted text-uppercase">Country</label>
                            <input type="text" name="country" class="form-control form-control-lg" value="India" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-zomato w-100 py-3 rounded-3 fw-bold fs-5 shadow-sm">Save Address & Continue</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Online Payment Details Modal (Asking for Payment) -->
<div class="modal fade" id="onlinePaymentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <h5 class="modal-title fw-bold fs-4">Payment Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-4">
                    <p class="text-muted small">Choose your preferred online method</p>
                    <div class="d-flex gap-2 mb-3">
                        <button type="button" id="upiTabBtn" class="btn btn-outline-secondary btn-sm flex-grow-1 active" onclick="togglePaymentTab('upi')">
                            <i class="fas fa-mobile-alt me-2"></i>UPI
                        </button>
                        <button type="button" id="cardTabBtn" class="btn btn-outline-secondary btn-sm flex-grow-1" onclick="togglePaymentTab('card')">
                            <i class="fas fa-credit-card me-2"></i>Cards
                        </button>
                    </div>
                    
                    <!-- UPI Section -->
                    <div id="upiInputSection">
                        <label class="form-label small fw-bold text-muted text-uppercase">Enter UPI ID</label>
                        <div class="input-group">
                            <input type="text" id="upiIdField" class="form-control form-control-lg" placeholder="e.g. mobile@ybl">
                            <button type="button" class="btn btn-zomato" onclick="simulateVerify(this)">Verify</button>
                        </div>
                        <div class="form-text mt-2">A request will be sent to your UPI app.</div>
                    </div>

                    <!-- Card Section (Hidden by default) -->
                    <div id="cardInputSection" style="display: none;">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted text-uppercase">Card Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fas fa-credit-card text-muted"></i></span>
                                <input type="text" id="cardNumberField" class="form-control form-control-lg border-start-0" placeholder="0000 0000 0000 0000">
                            </div>
                        </div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Expiry</label>
                                <input type="text" id="cardExpiryField" class="form-control form-control-lg" placeholder="MM/YY">
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">CVV</label>
                                <input type="password" id="cardCvvField" class="form-control form-control-lg" placeholder="***">
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-light p-3 rounded-3 mb-4">
                    <div class="d-flex justify-content-between mb-1 small text-muted">
                        <span>Paying to</span>
                        <span class="fw-bold text-dark">Zomato Food Delivery</span>
                    </div>
                    <div class="d-flex justify-content-between small text-muted">
                        <span>Total Amount</span>
                        <span class="fw-bold text-zomato-red">₹${total + (total * 0.05)}</span>
                    </div>
                </div>
                
                <button type="button" id="confirmOnlineDetailsBtn" class="btn btn-zomato w-100 py-3 rounded-3 fw-bold fs-5 shadow-sm">Confirm & Proceed</button>
            </div>
        </div>
    </div>
</div>

<!-- Payment Simulation Modal -->
<div class="modal fade" id="paymentModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg text-center p-5">
            <div id="paymentProcessing">
                <div class="spinner-border text-zomato-red mb-4" style="width: 3rem; height: 3rem;" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <h4 class="fw-bold mb-2">Connecting to Bank...</h4>
                <p id="processingSubtext" class="text-zomato-gray small m-0">Waiting for approval on your UPI app.</p>
                <div class="progress mt-4" style="height: 6px;">
                    <div id="paymentProgressBar" class="progress-bar bg-zomato-red progress-bar-striped progress-bar-animated" style="width: 0%"></div>
                </div>
            </div>
            
            <div id="paymentSuccess" class="d-none">
                <div class="bg-success rounded-circle d-inline-flex align-items-center justify-content-center mb-4 text-white shadow" style="width: 80px; height: 80px;">
                    <i class="fas fa-check fs-1"></i>
                </div>
                <h4 class="fw-bold mb-2 text-success">Transaction Successful!</h4>
                <p class="text-zomato-gray small m-0">Order is being placed...</p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        let paymentDetailsConfirmed = false;
        let activeTab = 'upi';
        const onlinePaymentModal = new bootstrap.Modal(document.getElementById('onlinePaymentModal'));
        const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));

        // Handle Tab Switching
        window.togglePaymentTab = function(tab) {
            activeTab = tab;
            const upiSection = document.getElementById('upiInputSection');
            const cardSection = document.getElementById('cardInputSection');
            const upiTab = document.getElementById('upiTabBtn');
            const cardTab = document.getElementById('cardTabBtn');

            if (tab === 'upi') {
                upiSection.style.display = 'block';
                cardSection.style.display = 'none';
                upiTab.classList.add('active');
                cardTab.classList.remove('active');
            } else {
                upiSection.style.display = 'none';
                cardSection.style.display = 'block';
                cardTab.classList.add('active');
                upiTab.classList.remove('active');
            }
        };

        // Simulate Verify Animation
        window.simulateVerify = function(btn) {
            const originalText = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
            setTimeout(() => {
                btn.innerHTML = '<i class="fas fa-check"></i>';
                btn.classList.replace('btn-zomato', 'btn-success');
                setTimeout(() => {
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                    btn.classList.replace('btn-success', 'btn-zomato');
                }, 2000);
            }, 1000);
        };

        // Handle Address Selection
        document.body.addEventListener('click', (e) => {
            const addrBtn = e.target.closest('.select-address-btn');
            if (addrBtn) {
                document.querySelectorAll('.address-box').forEach(el => el.classList.remove('selected'));
                addrBtn.classList.add('selected');
                document.getElementById('selectedAddressId').value = addrBtn.getAttribute('data-address-id');
            }

            const paymentBtn = e.target.closest('.select-payment-btn');
            if (paymentBtn) {
                document.querySelectorAll('.payment-box').forEach(el => el.classList.remove('selected'));
                paymentBtn.classList.add('selected');
                const method = paymentBtn.getAttribute('data-method');
                document.getElementById('selectedPaymentMethod').value = method;
                
                if (method === 'ONLINE' && !paymentDetailsConfirmed) {
                    onlinePaymentModal.show();
                }
            }
        });

        // Handle Confirm Online Details
        document.getElementById('confirmOnlineDetailsBtn').addEventListener('click', () => {
            let detailText = "";
            if (activeTab === 'upi') {
                const upiId = document.getElementById('upiIdField').value;
                if (!upiId || !upiId.includes('@')) {
                    alert("Please enter a valid UPI ID");
                    return;
                }
                detailText = '<i class="fas fa-check-circle text-success me-1"></i> UPI: ' + upiId;
            } else {
                const cardNum = document.getElementById('cardNumberField').value;
                if (!cardNum || cardNum.length < 12) {
                    alert("Please enter a valid Card Number");
                    return;
                }
                detailText = '<i class="fas fa-check-circle text-success me-1"></i> Card: **** ' + cardNum.slice(-4);
            }

            paymentDetailsConfirmed = true;
            onlinePaymentModal.hide();
            document.querySelector('.payment-box[data-method="ONLINE"] .text-zomato-gray').innerHTML = detailText;
        });

        // Auto-select first address if available
        const firstAddr = document.querySelector('.select-address-btn');
        if(firstAddr) firstAddr.click();

        // Payment Processing Simulation
        const placeOrderBtn = document.getElementById('placeOrderBtn');
        const checkoutForm = document.getElementById('checkoutForm');

        placeOrderBtn.addEventListener('click', () => {
            const addressInput = document.getElementById('selectedAddressId');
            const addressId = addressInput ? addressInput.value : '';
            const paymentMethod = document.getElementById('selectedPaymentMethod').value;

            if (!addressId) {
                alert("Please add and select a delivery address.");
                return;
            }

            if (paymentMethod === 'ONLINE') {
                if (!paymentDetailsConfirmed) {
                    onlinePaymentModal.show();
                    return;
                }
                
                // Show final simulation
                const simulationModalEl = document.getElementById('paymentModal');
                const simModal = new bootstrap.Modal(simulationModalEl);
                simModal.show();
                
                let progress = 0;
                const progressBar = document.getElementById('paymentProgressBar');
                
                const interval = setInterval(() => {
                    progress += 10;
                    progressBar.style.width = progress + '%';
                    
                    if (progress == 40) document.getElementById('processingSubtext').textContent = "Authenticating with bank...";
                    if (progress == 80) document.getElementById('processingSubtext').textContent = "Finalizing transaction...";

                    if (progress >= 100) {
                        clearInterval(interval);
                        setTimeout(() => {
                            document.getElementById('paymentProcessing').classList.add('d-none');
                            document.getElementById('paymentSuccess').classList.remove('d-none');
                            
                            // Submit actual form after success
                            setTimeout(() => {
                                checkoutForm.submit();
                            }, 1500);
                        }, 500);
                    }
                }, 400);
            } else {
                // Directly submit if COD
                checkoutForm.submit();
            }
        });
    });
</script>

</body>
</html>
