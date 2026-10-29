<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Bus' : 'Add New Bus'} - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="buses" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">${isEdit ? 'Edit Bus Coach' : 'Add New Bus Coach'}</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Configure bus registration, seating capacity, and onboard amenities</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/buses" class="btn btn-outline btn-sm">&larr; Back to Buses</a>
</div>

<div class="form-card">
    <form action="${pageContext.request.contextPath}/admin/buses/${isEdit ? 'edit/' : 'new'}${isEdit ? bus.id : ''}" method="POST">
        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="busNumber">Bus Plate / Registration Number</label>
                <input type="text" id="busNumber" name="busNumber" value="${bus.busNumber}" class="form-control" placeholder="e.g. TS09UB1001" required />
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="busName">Bus Name / Fleet Operator</label>
                <input type="text" id="busName" name="busName" value="${bus.busName}" class="form-control" placeholder="e.g. Garuda Vega Express" required />
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="busType">Bus Model & Type</label>
                <select id="busType" name="busType" class="form-control" required>
                    <option value="Volvo Multi-Axle AC (2+2)" ${bus.busType == 'Volvo Multi-Axle AC (2+2)' ? 'selected' : ''}>Volvo Multi-Axle AC (2+2)</option>
                    <option value="AC Sleeper (2+1)" ${bus.busType == 'AC Sleeper (2+1)' ? 'selected' : ''}>AC Sleeper (2+1)</option>
                    <option value="Scania Multi-Axle AC (2+2)" ${bus.busType == 'Scania Multi-Axle AC (2+2)' ? 'selected' : ''}>Scania Multi-Axle AC (2+2)</option>
                    <option value="BharatBenz AC Sleeper (2+1)" ${bus.busType == 'BharatBenz AC Sleeper (2+1)' ? 'selected' : ''}>BharatBenz AC Sleeper (2+1)</option>
                    <option value="Volvo 9600 AC Sleeper" ${bus.busType == 'Volvo 9600 AC Sleeper' ? 'selected' : ''}>Volvo 9600 AC Sleeper</option>
                    <option value="Non-AC Hi-Tech Seater (2+2)" ${bus.busType == 'Non-AC Hi-Tech Seater (2+2)' ? 'selected' : ''}>Non-AC Hi-Tech Seater (2+2)</option>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="totalSeats">Total Seat Capacity</label>
                <input type="number" id="totalSeats" name="totalSeats" value="${bus.totalSeats != null ? bus.totalSeats : 32}" min="10" max="60" class="form-control" required />
            </div>
        </div>

        <div class="form-group" style="margin-bottom: 18px;">
            <label class="form-label" for="amenities">Amenities (Comma separated)</label>
            <input type="text" id="amenities" name="amenities" value="${bus.amenities}" class="form-control" placeholder="e.g. Free High-Speed WiFi, USB Charging Port, Reading Light, Water Bottle" />
        </div>

        <div class="form-group" style="margin-bottom: 24px;">
            <label class="checkbox-label" style="font-weight: 600;">
                <input type="checkbox" name="isActive" value="true" ${bus.isActive != false ? 'checked' : ''} />
                Coach is Active and Available for Scheduling
            </label>
        </div>

        <div style="display: flex; gap: 12px;">
            <button type="submit" class="btn btn-primary btn-lg">
                ${isEdit ? 'Update Bus Coach' : 'Save Bus Coach'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/buses" class="btn btn-outline btn-lg">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
