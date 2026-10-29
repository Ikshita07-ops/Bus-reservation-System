<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Registered Users - VoyageBus Admin" scope="request" />
<c:set var="adminNav" value="users" scope="request" />
<jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">Registered Customer & Admin Accounts</h1>
        <p style="font-size: 14px; color: var(--color-text-muted);">View registered user credentials, contact details, and role privileges</p>
    </div>
</div>

<div class="table-card">
    <div class="table-card-header">
        <h3 class="table-card-title">All Users (${users.size()} accounts)</h3>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>User ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Phone Number</th>
                <th>Assigned Role</th>
                <th>Registration Date</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${users}" var="u">
                <tr>
                    <td>#${u.id}</td>
                    <td style="font-weight: 600;">${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td>
                        <span class="badge ${u.admin ? 'badge-danger' : 'badge-info'}">
                            ${u.role}
                        </span>
                    </td>
                    <td style="font-size: 13px; color: var(--color-text-muted);">${u.createdAt}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
