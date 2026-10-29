<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Schedule' : 'Add New Schedule'} - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="schedules" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">${isEdit ? 'Edit Schedule & Fare' : 'Add New Schedule & Departure'}</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Assign an active coach to an intercity route and schedule departure time and fare</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-outline btn-sm">&larr; Back to Schedules</a>
</div>

<div class="form-card">
    <form action="${pageContext.request.contextPath}/admin/schedules/${isEdit ? 'edit/' : 'new'}${isEdit ? schedule.id : ''}" method="POST">
        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="busId">Select Bus Coach</label>
                <select id="busId" name="busId" class="form-control" required>
                    <option value="">Select available bus</option>
                    <c:forEach items="${buses}" var="b">
                        <option value="${b.id}" ${schedule.bus != null && schedule.bus.id == b.id ? 'selected' : ''}>
                            ${b.busName} (${b.busNumber} • ${b.busType})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="routeId">Select Route</label>
                <select id="routeId" name="routeId" class="form-control" required>
                    <option value="">Select intercity route</option>
                    <c:forEach items="${routes}" var="r">
                        <option value="${r.id}" ${schedule.route != null && schedule.route.id == r.id ? 'selected' : ''}>
                            ${r.sourceCity} &rarr; ${r.destinationCity} (${r.distanceKm} km • ${r.estimatedDuration})
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="journeyDate">Journey Date</label>
                <input type="date" id="journeyDate" name="journeyDate" value="${schedule.journeyDate}" class="form-control" required />
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="fare">Base Ticket Fare (INR)</label>
                <input type="number" id="fare" name="fare" step="0.01" value="${schedule.fare}" min="50" class="form-control" placeholder="e.g. 1250.00" required />
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="departureTime">Departure Time</label>
                <input type="time" id="departureTime" name="departureTime" value="${schedule.departureTime}" class="form-control" required />
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="arrivalTime">Arrival Time</label>
                <input type="time" id="arrivalTime" name="arrivalTime" value="${schedule.arrivalTime}" class="form-control" required />
            </div>
        </div>

        <c:if test="${isEdit}">
            <div class="form-group" style="margin-bottom: 24px;">
                <label class="form-label" for="status">Schedule Status</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="SCHEDULED" ${schedule.status == 'SCHEDULED' ? 'selected' : ''}>SCHEDULED (Active for Booking)</option>
                    <option value="COMPLETED" ${schedule.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED (Journey Ended)</option>
                    <option value="CANCELLED" ${schedule.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED (Journey Cancelled)</option>
                </select>
            </div>
        </c:if>

        <div style="display: flex; gap: 12px; margin-top: 12px;">
            <button type="submit" class="btn btn-primary btn-lg">
                ${isEdit ? 'Update Schedule' : 'Save Schedule'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-outline btn-lg">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
