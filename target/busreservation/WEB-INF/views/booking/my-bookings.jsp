<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Bookings - VoyageBus Express" scope="request" />
<c:set var="currentNav" value="my-bookings" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container">
        <div class="section-header">
            <div>
                <h1 class="section-title">My Bookings & Travel History</h1>
                <p class="section-subtitle">Manage upcoming trips, download boarding passes, or cancel bookings</p>
            </div>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary btn-sm">
                + Book New Ticket
            </a>
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

        <c:choose>
            <c:when test="${empty bookings}">
                <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 48px; text-align: center; box-shadow: var(--shadow-sm);">
                    <div style="font-size: 40px; margin-bottom: 12px; color: var(--color-primary);">🎫</div>
                    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">No reservations found</h3>
                    <p style="color: var(--color-text-muted); font-size: 14px; margin-bottom: 24px;">You haven't booked any bus journeys yet. Find your next route now!</p>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Find Buses</a>
                </div>
            </c:when>

            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 16px;">
                    <c:forEach items="${bookings}" var="b">
                        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm); display: grid; grid-template-columns: 2fr 1.5fr 1fr auto; gap: 24px; align-items: center;">
                            <div>
                                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
                                    <span style="font-size: 18px; font-weight: 700; color: var(--color-text);">
                                        ${b.schedule.route.sourceCity} &rarr; ${b.schedule.route.destinationCity}
                                    </span>
                                    <span class="badge ${b.confirmed ? 'badge-success' : 'badge-danger'}">
                                        ${b.bookingStatus}
                                    </span>
                                </div>
                                <div style="font-size: 13px; color: var(--color-text-muted);">
                                    ${b.schedule.bus.busName} • Reference: <strong style="color: var(--color-text); font-family: monospace;">${b.bookingReference}</strong>
                                </div>
                                <div style="font-size: 12px; color: var(--color-text-light); margin-top: 4px;">
                                    Booked on ${b.formattedBookingDate}
                                </div>
                            </div>

                            <div>
                                <div style="font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-muted);">Journey Date & Time</div>
                                <div style="font-size: 15px; font-weight: 700; color: var(--color-text);">
                                    ${b.schedule.formattedJourneyDate}
                                </div>
                                <div style="font-size: 13px; color: var(--color-text-muted);">
                                    ${b.schedule.formattedDepartureTime} - ${b.schedule.formattedArrivalTime}
                                </div>
                            </div>

                            <div>
                                <div style="font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-muted);">Seats & Fare</div>
                                <div style="font-size: 15px; font-weight: 700; color: var(--color-primary);">
                                    INR ${b.totalFare}
                                </div>
                                <div style="font-size: 13px; color: var(--color-text);">
                                    Seat(s): <strong>${b.seatNumbersAsString}</strong>
                                </div>
                            </div>

                            <div style="display: flex; flex-direction: column; gap: 8px;">
                                <a href="${pageContext.request.contextPath}/booking/ticket/${b.bookingReference}" class="btn btn-outline btn-sm">
                                    View Ticket
                                </a>

                                <c:if test="${b.eligibleForCancellation}">
                                    <form action="${pageContext.request.contextPath}/booking/cancel/${b.id}" method="POST" onsubmit="return confirm('Are you sure you want to cancel this booking? The seats will be immediately released.');">
                                        <button type="submit" class="btn btn-danger btn-sm" style="width: 100%;">
                                            Cancel Booking
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${b.cancelled}">
                                    <span style="font-size: 11px; color: #B71C1C; text-align: center;">Cancelled on<br>${b.formattedCancelledAt}</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
