<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Route' : 'Add New Route'} - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="routes" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">${isEdit ? 'Edit Intercity Route' : 'Add New Intercity Route'}</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Configure terminal cities, highway distance, and estimated travel time</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/routes" class="btn btn-outline btn-sm">&larr; Back to Routes</a>
</div>

<div class="form-card">
    <form action="${pageContext.request.contextPath}/admin/routes/${isEdit ? 'edit/' : 'new'}${isEdit ? route.id : ''}" method="POST">
        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="sourceCity">Source / Origin City</label>
                <input type="text" id="sourceCity" name="sourceCity" value="${route.sourceCity}" class="form-control" placeholder="e.g. Hyderabad" required />
            </div>

            <div class="form-group" style="margin-bottom: 18px;">
                <label class="form-label" for="destinationCity">Destination / Arrival City</label>
                <input type="text" id="destinationCity" name="destinationCity" value="${route.destinationCity}" class="form-control" placeholder="e.g. Bangalore" required />
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group" style="margin-bottom: 24px;">
                <label class="form-label" for="distanceKm">Distance (in Kilometers)</label>
                <input type="number" id="distanceKm" name="distanceKm" value="${route.distanceKm}" min="1" class="form-control" placeholder="e.g. 570" required />
            </div>

            <div class="form-group" style="margin-bottom: 24px;">
                <label class="form-label" for="estimatedDuration">Estimated Duration</label>
                <input type="text" id="estimatedDuration" name="estimatedDuration" value="${route.estimatedDuration}" class="form-control" placeholder="e.g. 8 hrs 30 mins" required />
            </div>
        </div>

        <div style="display: flex; gap: 12px;">
            <button type="submit" class="btn btn-primary btn-lg">
                ${isEdit ? 'Update Route' : 'Save Route'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/routes" class="btn btn-outline btn-lg">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
