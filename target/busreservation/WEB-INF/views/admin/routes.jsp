<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Manage Routes - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="routes" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Manage Intercity Routes</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">Configure origin and destination city connections, distances, and travel durations</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/routes/new" class="btn btn-primary">
        + Add New Route
    </a>
</div>

<div class="table-card">
    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Source City (Origin)</th>
                <th>Destination City (Arrival)</th>
                <th>Distance</th>
                <th>Estimated Duration</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${routes}" var="r">
                <tr>
                    <td>#${r.id}</td>
                    <td style="font-weight: 600;">${r.sourceCity}</td>
                    <td style="font-weight: 600;">${r.destinationCity}</td>
                    <td>${r.distanceKm} km</td>
                    <td>${r.estimatedDuration}</td>
                    <td>
                        <div style="display: flex; gap: 6px;">
                            <a href="${pageContext.request.contextPath}/admin/routes/edit/${r.id}" class="btn btn-outline btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/routes/delete/${r.id}" method="POST" onsubmit="return confirm('Are you sure you want to delete route ${r.sourceCity} to ${r.destinationCity}?');">
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
