<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Select Seats - VoyageBus Express" scope="request" />
<c:set var="currentNav" value="search" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container">
        <!-- Journey Info Banner -->
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 20px 24px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: var(--shadow-sm);">
            <div>
                <a href="${pageContext.request.contextPath}/search?source=${schedule.route.sourceCity}&destination=${schedule.route.destinationCity}&journeyDate=${schedule.journeyDate}" style="font-size: 13px; font-weight: 600; color: var(--color-primary); margin-bottom: 4px; display: inline-block;">
                    &larr; Back to Search Results
                </a>
                <h1 style="font-size: 22px; font-weight: 700; color: var(--color-text);">
                    ${schedule.route.sourceCity} &rarr; ${schedule.route.destinationCity}
                </h1>
                <div style="font-size: 14px; color: var(--color-text-muted); margin-top: 4px;">
                    ${schedule.bus.busName} (${schedule.bus.busType}) • ${schedule.formattedJourneyDate} • Departs at ${schedule.formattedDepartureTime}
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-muted);">Base Fare per Seat</div>
                <div style="font-size: 24px; font-weight: 700; color: var(--color-primary);">INR ${schedule.fare}</div>
                <div style="font-size: 13px; font-weight: 600; color: var(--color-success);">${availableCount} seats left</div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <div class="seat-selection-container">
            <!-- Left: Interactive Coach Visual -->
            <div class="bus-layout-card">
                <div style="text-align: center; margin-bottom: 20px;">
                    <h2 style="font-size: 16px; font-weight: 700; color: var(--color-text);">Interactive Coach Layout</h2>
                    <p style="font-size: 13px; color: var(--color-text-muted);">Click on available seats to select. Click again to remove.</p>
                </div>

                <div class="bus-coach">
                    <div class="bus-front">
                        <span style="font-size: 12px; font-weight: 700; color: var(--color-text-muted); text-transform: uppercase;">Front / Entry Door</span>
                        <div class="steering-wheel" title="Driver Cabin"></div>
                    </div>

                    <c:set var="isSleeper" value="${schedule.bus.busType.toLowerCase().contains('sleeper')}" />

                    <c:choose>
                        <c:when test="${isSleeper}">
                            <!-- Sleeper Layout: Lower and Upper Deck Sections -->
                            <div class="deck-title">Lower Deck (Berths)</div>
                            <div class="seats-grid seats-grid-sleeper" style="margin-bottom: 32px;">
                                <c:forEach items="${seatMap}" var="s">
                                    <c:if test="${s.deck == 'LOWER'}">
                                        <div class="seat sleeper-seat ${s.booked ? 'booked' : ''}" 
                                             data-seat="${s.seatNumber}" 
                                             title="Lower Berth ${s.seatNumber} - INR ${s.fare} ${s.booked ? '(Booked)' : '(Available)'}">
                                            ${s.seatNumber}
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <div class="deck-title" style="border-top: 1px dashed var(--color-border-dark); padding-top: 16px;">Upper Deck (Berths)</div>
                            <div class="seats-grid seats-grid-sleeper">
                                <c:forEach items="${seatMap}" var="s">
                                    <c:if test="${s.deck == 'UPPER'}">
                                        <div class="seat sleeper-seat ${s.booked ? 'booked' : ''}" 
                                             data-seat="${s.seatNumber}" 
                                             title="Upper Berth ${s.seatNumber} - INR ${s.fare} ${s.booked ? '(Booked)' : '(Available)'}">
                                            ${s.seatNumber}
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <!-- Seater Layout (2+2 Rows) -->
                            <div class="deck-title">Main Cabin (2+2 Luxury Seater)</div>
                            <div class="seats-grid seats-grid-seater">
                                <c:forEach items="${seatMap}" var="s">
                                    <div class="seat ${s.booked ? 'booked' : ''}" 
                                         data-seat="${s.seatNumber}" 
                                         title="Seat ${s.seatNumber} - INR ${s.fare} ${s.booked ? '(Booked)' : '(Available)'}">
                                        ${s.seatNumber}
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Seat Legend -->
                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-box legend-avail"></div>
                            <span>Available</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-box legend-selected"></div>
                            <span>Selected</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-box legend-booked"></div>
                            <span>Booked</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Sticky Booking Summary -->
            <div>
                <div class="summary-card">
                    <h3 class="summary-title">Reservation Summary</h3>

                    <input type="hidden" id="scheduleFare" value="${schedule.fare}" />

                    <div class="summary-row">
                        <span style="color: var(--color-text-muted);">Bus Service:</span>
                        <span style="font-weight: 600;">${schedule.bus.busName}</span>
                    </div>

                    <div class="summary-row">
                        <span style="color: var(--color-text-muted);">Route:</span>
                        <span style="font-weight: 600;">${schedule.route.sourceCity} &rarr; ${schedule.route.destinationCity}</span>
                    </div>

                    <div class="summary-row">
                        <span style="color: var(--color-text-muted);">Journey Date:</span>
                        <span style="font-weight: 600;">${schedule.formattedJourneyDate}</span>
                    </div>

                    <div class="summary-row">
                        <span style="color: var(--color-text-muted);">Departure:</span>
                        <span style="font-weight: 600;">${schedule.formattedDepartureTime}</span>
                    </div>

                    <div class="summary-row" style="border-top: 1px dashed var(--color-border); padding-top: 10px; margin-top: 10px;">
                        <span style="color: var(--color-text-muted);">Selected Seats:</span>
                        <div id="selectedSeatsDisplay" style="text-align: right; max-width: 180px;">
                            <span style="color: #999;">No seats selected</span>
                        </div>
                    </div>

                    <div class="summary-row">
                        <span style="color: var(--color-text-muted);">Fare per seat:</span>
                        <span style="font-weight: 600;">INR ${schedule.fare}</span>
                    </div>

                    <div class="summary-row total">
                        <span>Total Payable:</span>
                        <span id="totalFareDisplay">INR 0.00</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/booking/checkout" method="GET" style="margin-top: 24px;">
                        <input type="hidden" name="scheduleId" value="${schedule.id}" />
                        <input type="hidden" id="selectedSeatsInput" name="seats" value="" />

                        <button type="submit" id="proceedToCheckoutBtn" class="btn btn-primary btn-block btn-lg" disabled style="opacity: 0.6; cursor: not-allowed;">
                            Proceed to Booking &rarr;
                        </button>
                    </form>

                    <div style="font-size: 12px; color: var(--color-text-muted); text-align: center; margin-top: 12px;">
                        🔒 Concurrency-safe seat allocation
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/seat-selection.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
