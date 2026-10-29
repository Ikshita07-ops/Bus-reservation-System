<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="All Reservations - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="bookings" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Manage Customer Reservations</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">View all passenger tickets, track status, and manage administrative cancellations</p>
    </div>
</div>

<div class="table-card">
    <div class="table-card-header">
        <h3 class="table-card-title">All Bookings (${bookings.size()} records)</h3>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Booking Ref</th>
                <th>Passenger Details</th>
                <th>Account</th>
                <th>Journey / Route</th>
                <th>Date & Time</th>
                <th>Seats</th>
                <th>Fare</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty bookings}">
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 32px; color: var(--color-text-muted);">
                            No customer reservations found in database.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${bookings}" var="b">
                        <tr>
                            <td>
                                <strong style="font-family: monospace; color: var(--color-primary);">${b.bookingReference}</strong>
                                <div style="font-size: 11px; color: var(--color-text-light);">${b.formattedBookingDate}</div>
                            </td>
                            <td>
                                <div style="font-weight: 600;">${b.passengerName}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.passengerEmail}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.passengerPhone}</div>
                            </td>
                            <td>
                                <div style="font-size: 13px;">${b.user.fullName}</div>
                                <div style="font-size: 11px; color: var(--color-text-muted);">${b.user.email}</div>
                            </td>
                            <td>
                                <div style="font-weight: 600;">${b.schedule.route.sourceCity} &rarr; ${b.schedule.route.destinationCity}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.schedule.bus.busName}</div>
                            </td>
                            <td>
                                <div>${b.schedule.formattedJourneyDate}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.schedule.formattedDepartureTime}</div>
                            </td>
                            <td>
                                <strong style="color: var(--color-primary);">${b.seatNumbersAsString}</strong>
                                <div style="font-size: 11px; color: var(--color-text-muted);">${b.totalSeats} seat(s)</div>
                            </td>
                            <td style="font-weight: 700;">INR ${b.totalFare}</td>
                            <td>
                                <span class="badge ${b.confirmed ? 'badge-success' : 'badge-danger'}">
                                    ${b.bookingStatus}
                                </span>
                            </td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <a href="${pageContext.request.contextPath}/booking/ticket/${b.bookingReference}" class="btn btn-outline btn-sm" target="_blank">
                                        View Ticket
                                    </a>
                                    <c:if test="${b.confirmed}">
                                        <form action="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}" method="POST" onsubmit="return confirm('Cancel reservation ${b.bookingReference} as Admin? Allocated seats will be instantly released.');">
                                            <button type="submit" class="btn btn-danger btn-sm" style="width: 100%;">
                                                Cancel
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
