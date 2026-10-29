<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <div class="brand">
                    <div class="brand-logo">V</div>
                    <div class="brand-text">Voyage<span>Bus</span></div>
                </div>
                <p>VoyageBus Express is a premier, reliable online bus reservation platform connecting thousands of travelers across top intercity routes with real-time seat tracking and verified operators.</p>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/search">Search Buses</a></li>
                    <li><a href="${pageContext.request.contextPath}/booking/my-bookings">My Bookings</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Top Routes</h4>
                <ul>
                    <li><a href="javascript:void(0)" onclick="selectQuickRoute('Hyderabad', 'Bangalore')">Hyderabad → Bangalore</a></li>
                    <li><a href="javascript:void(0)" onclick="selectQuickRoute('Bangalore', 'Chennai')">Bangalore → Chennai</a></li>
                    <li><a href="javascript:void(0)" onclick="selectQuickRoute('Mumbai', 'Pune')">Mumbai → Pune</a></li>
                    <li><a href="javascript:void(0)" onclick="selectQuickRoute('Delhi', 'Jaipur')">Delhi → Jaipur</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Customer Support</h4>
                <ul>
                    <li style="color: var(--color-text-muted); font-size: 14px;">Toll-Free: 1800 200 4567</li>
                    <li style="color: var(--color-text-muted); font-size: 14px;">Email: support@voyagebus.com</li>
                    <li style="color: var(--color-text-muted); font-size: 14px;">24/7 Booking Assistance</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <div>&copy; 2026 VoyageBus Express. All rights reserved. Built with Spring MVC, Hibernate & MySQL.</div>
            <div>Secure Transactions • 100% Concurrency Safe • Verified Operators</div>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
