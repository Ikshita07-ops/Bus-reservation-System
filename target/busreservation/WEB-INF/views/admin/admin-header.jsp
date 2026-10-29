<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isAdminSection" value="true" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="admin-layout">
    <aside class="admin-sidebar">
        <div style="padding: 0 24px 16px 24px; font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--color-text-muted); letter-spacing: 1px;">
            Admin Console
        </div>
        <ul class="admin-sidebar-menu">
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-link ${adminNav == 'dashboard' ? 'active' : ''}">
                    📊 Dashboard
                </a>
            </li>
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/buses" class="admin-menu-link ${adminNav == 'buses' ? 'active' : ''}">
                    🚌 Manage Buses
                </a>
            </li>
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/routes" class="admin-menu-link ${adminNav == 'routes' ? 'active' : ''}">
                    🗺 Routes & Cities
                </a>
            </li>
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/schedules" class="admin-menu-link ${adminNav == 'schedules' ? 'active' : ''}">
                    📅 Schedules & Fares
                </a>
            </li>
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/bookings" class="admin-menu-link ${adminNav == 'bookings' ? 'active' : ''}">
                    🎫 All Reservations
                </a>
            </li>
            <li class="admin-menu-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="admin-menu-link ${adminNav == 'users' ? 'active' : ''}">
                    👥 Registered Users
                </a>
            </li>
        </ul>
    </aside>

    <main class="admin-main">
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
