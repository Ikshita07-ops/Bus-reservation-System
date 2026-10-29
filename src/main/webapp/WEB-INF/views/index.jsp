<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="VoyageBus Express - Fast, Safe & Reliable Bus Reservation" scope="request" />
<c:set var="currentNav" value="home" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Hero & Search Widget -->
<section class="hero-section">
    <div class="container">
        <div class="hero-header">
            <h1 class="hero-title">Connecting Cities with <span>Comfort & Speed</span></h1>
            <p class="hero-subtitle">Book verified Volvo, AC Sleeper, and Luxury intercity buses with live seat tracking and instant booking confirmation.</p>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <span>${successMessage}</span>
                <span class="alert-close" style="cursor:pointer; font-weight:bold;">&times;</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>${errorMessage}</span>
                <span class="alert-close" style="cursor:pointer; font-weight:bold;">&times;</span>
            </div>
        </c:if>

        <div class="search-card">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form">
                <div class="form-group">
                    <label class="form-label" for="searchSource">From (Departure City)</label>
                    <select id="searchSource" name="source" class="form-control" required>
                        <option value="">Select departure city</option>
                        <c:forEach items="${sources}" var="src">
                            <option value="${src}" ${src == 'Hyderabad' ? 'selected' : ''}>${src}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="searchDestination">To (Arrival City)</label>
                    <select id="searchDestination" name="destination" class="form-control" required>
                        <option value="">Select arrival city</option>
                        <c:forEach items="${destinations}" var="dst">
                            <option value="${dst}" ${dst == 'Bangalore' ? 'selected' : ''}>${dst}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="journeyDate">Date of Journey</label>
                    <input type="date" id="journeyDate" name="journeyDate" value="${today}" min="${today}" class="form-control" required />
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="height: 48px;">
                    Search Buses
                </button>
            </form>
        </div>

        <!-- Trust Badges -->
        <div class="trust-strip">
            <div class="trust-item">
                <div class="trust-icon">✓</div>
                <div class="trust-text">
                    <h4>Live Seat Selection</h4>
                    <p>Select your exact seat or berth with 100% concurrency-safe database locking.</p>
                </div>
            </div>
            <div class="trust-item">
                <div class="trust-icon">⚡</div>
                <div class="trust-text">
                    <h4>Instant Confirmation</h4>
                    <p>Get immediate boarding pass tickets with printable references and booking details.</p>
                </div>
            </div>
            <div class="trust-item">
                <div class="trust-icon">↺</div>
                <div class="trust-text">
                    <h4>Easy Cancellation</h4>
                    <p>Hassle-free one-click cancellation with immediate seat release for other passengers.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Popular Routes Section -->
<div class="main-content">
    <div class="container">
        <div class="section-header">
            <div>
                <h2 class="section-title">Popular Intercity Routes</h2>
                <p class="section-subtitle">Top traveled routes with multiple daily luxury departures</p>
            </div>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-outline btn-sm">View All Routes &rarr;</a>
        </div>

        <div class="routes-grid">
            <c:forEach items="${popularRoutes}" var="r">
                <div class="route-card">
                    <div>
                        <div class="route-cities">${r.sourceCity} &rarr; ${r.destinationCity}</div>
                        <div class="route-meta">Distance: ${r.distanceKm} km • Approx ${r.estimatedDuration}</div>
                    </div>
                    <div>
                        <a href="javascript:void(0)" onclick="selectQuickRoute('${r.sourceCity}', '${r.destinationCity}')" class="btn btn-outline-primary btn-sm btn-block">
                            View Available Buses
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
