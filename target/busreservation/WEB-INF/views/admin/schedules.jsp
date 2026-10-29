<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Manage Schedules - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="schedules" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Manage Schedules & Departures</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Configure timetable, assign coaches to routes, and set dynamic seat fares</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/schedules/new" class="btn btn-primary">
        + Add New Schedule
    </a>
</div>

<div class="table-card">
    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Bus & Operator</th>
                <th>Route</th>
                <th>Journey Date</th>
                <th>Timings</th>
                <th>Fare</th>
                <th>Available Seats</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${schedules}" var="s">
                <tr>
                    <td>#${s.id}</td>
                    <td>
                        <div style="font-weight: 600;">${s.bus.busName}</div>
                        <div style="font-size: 12px; color: var(--color-text-muted);">${s.bus.busNumber} • ${s.bus.busType}</div>
                    </td>
                    <td>
                        <div style="font-weight: 600;">${s.route.sourceCity} &rarr; ${s.route.destinationCity}</div>
                        <div style="font-size: 12px; color: var(--color-text-muted);">${s.route.estimatedDuration}</div>
                    </td>
                    <td>${s.formattedJourneyDate}</td>
                    <td>
                        <div><strong>${s.formattedDepartureTime}</strong> (Dep)</div>
                        <div style="font-size: 12px; color: var(--color-text-muted);">${s.formattedArrivalTime} (Arr)</div>
                    </td>
                    <td style="font-weight: 700; color: var(--color-primary);">INR ${s.fare}</td>
                    <td>
                        <span class="bus-seat-badge">${s.availableSeats} / ${s.bus.totalSeats} seats</span>
                    </td>
                    <td>
                        <span class="badge ${s.status == 'SCHEDULED' ? 'badge-success' : (s.status == 'CANCELLED' ? 'badge-danger' : 'badge-warning')}">
                            ${s.status}
                        </span>
                    </td>
                    <td>
                        <div style="display: flex; gap: 6px;">
                            <a href="${pageContext.request.contextPath}/admin/schedules/edit/${s.id}" class="btn btn-outline btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/schedules/delete/${s.id}" method="POST" onsubmit="return confirm('Delete this schedule? If bookings exist, deletion will be blocked.');">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
