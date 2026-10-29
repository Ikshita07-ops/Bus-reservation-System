<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Manage Buses - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="buses" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Manage Fleet & Buses</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">View, add, edit, or configure coaches in the system</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/buses/new" class="btn btn-primary">
        + Add New Bus
    </a>
</div>

<div class="table-card">
    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Bus Number</th>
                <th>Operator / Bus Name</th>
                <th>Bus Type</th>
                <th>Capacity</th>
                <th>Amenities</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${buses}" var="b">
                <tr>
                    <td>#${b.id}</td>
                    <td><strong>${b.busNumber}</strong></td>
                    <td style="font-weight: 600;">${b.busName}</td>
                    <td>${b.busType}</td>
                    <td>${b.totalSeats} Seats</td>
                    <td style="max-width: 250px; font-size: 13px; color: var(--color-text-muted);">${b.amenities}</td>
                    <td>
                        <span class="badge ${b.isActive ? 'badge-success' : 'badge-danger'}">
                            ${b.isActive ? 'Active' : 'Inactive'}
                        </span>
                    </td>
                    <td>
                        <div style="display: flex; gap: 6px;">
                            <a href="${pageContext.request.contextPath}/admin/buses/edit/${b.id}" class="btn btn-outline btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/buses/delete/${b.id}" method="POST" onsubmit="return confirm('Are you sure you want to delete bus ${b.busNumber}?');">
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
