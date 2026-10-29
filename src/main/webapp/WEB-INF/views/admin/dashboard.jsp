<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Dashboard - VoyageBus" scope="request" />
<c:set var="adminNav" value="dashboard" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Executive Dashboard</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Overview of fleet operations, bookings, and revenue metrics</p>
    </div>
    <div style="display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/admin/schedules/new" class="btn btn-primary btn-sm">+ Add Schedule</a>
        <a href="${pageContext.request.contextPath}/admin/buses/new" class="btn btn-outline btn-sm">+ Add Bus</a>
        <a href="${pageContext.request.contextPath}/admin/routes/new" class="btn btn-outline btn-sm">+ Add Route</a>
    </div>
</div>

<!-- Stats Grid -->
<div class="stats-grid">
    <div class="stat-card">
        <span class="stat-label">Total Revenue</span>
        <span class="stat-value primary">INR ${stats.totalRevenue}</span>
        <span style="font-size: 12px; color: var(--color-text-muted);">From confirmed bookings</span>
    </div>

    <div class="stat-card">
        <span class="stat-label">Active Bookings</span>
        <span class="stat-value">${stats.activeBookings}</span>
        <span style="font-size: 12px; color: var(--color-success);">${stats.totalBookings} total booked</span>
    </div>

    <div class="stat-card">
        <span class="stat-label">Registered Fleet</span>
        <span class="stat-value">${stats.totalBuses}</span>
        <span style="font-size: 12px; color: var(--color-text-muted);">Active coaches</span>
    </div>

    <div class="stat-card">
        <span class="stat-label">Total Routes</span>
        <span class="stat-value">${stats.totalRoutes}</span>
        <span style="font-size: 12px; color: var(--color-text-muted);">Intercity networks</span>
    </div>

    <div class="stat-card">
        <span class="stat-label">Active Schedules</span>
        <span class="stat-value">${stats.totalSchedules}</span>
        <span style="font-size: 12px; color: var(--color-text-muted);">Scheduled departures</span>
    </div>

    <div class="stat-card">
        <span class="stat-label">Registered Users</span>
        <span class="stat-value">${stats.totalUsers}</span>
        <span style="font-size: 12px; color: var(--color-text-muted);">Customer accounts</span>
    </div>
</div>

<!-- Recent Reservations Table -->
<div class="table-card">
    <div class="table-card-header">
        <h3 class="table-card-title">Recent Reservations</h3>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-outline btn-sm">View All Bookings &rarr;</a>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Reference</th>
                <th>Passenger</th>
                <th>Route</th>
                <th>Date & Time</th>
                <th>Seats</th>
                <th>Fare</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty stats.recentBookings}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 24px; color: var(--color-text-muted);">No reservations recorded yet.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${stats.recentBookings}" var="b">
                        <tr>
                            <td>
                                <strong style="font-family: monospace; color: var(--color-primary);">${b.bookingReference}</strong>
                            </td>
                            <td>
                                <div style="font-weight: 600;">${b.passengerName}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.passengerPhone}</div>
                            </td>
                            <td>${b.schedule.route.sourceCity} &rarr; ${b.schedule.route.destinationCity}</td>
                            <td>
                                <div>${b.schedule.formattedJourneyDate}</div>
                                <div style="font-size: 12px; color: var(--color-text-muted);">${b.schedule.formattedDepartureTime}</div>
                            </td>
                            <td><strong>${b.seatNumbersAsString}</strong></td>
                            <td>INR ${b.totalFare}</td>
                            <td>
                                <span class="badge ${b.confirmed ? 'badge-success' : 'badge-danger'}">
                                    ${b.bookingStatus}
                                </span>
                            </td>
                            <td>
                                <div style="display: flex; gap: 6px;">
                                    <a href="${pageContext.request.contextPath}/booking/ticket/${b.bookingReference}" class="btn btn-outline btn-sm" target="_blank">
                                        Ticket
                                    </a>
                                    <c:if test="${b.confirmed}">
                                        <form action="${pageContext.request.contextPath}/admin/bookings/cancel/${b.id}" method="POST" onsubmit="return confirm('Cancel this booking as Admin? Seats will be immediately released.');">
                                            <button type="submit" class="btn btn-danger btn-sm">
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
