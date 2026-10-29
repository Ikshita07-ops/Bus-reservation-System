<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "VoyageBus Express - Bus Reservation Management System"}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:if test="${isAdminSection}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
    </c:if>
</head>
<body>

<header class="site-header">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="brand">
            <div class="brand-logo">V</div>
            <div class="brand-text">Voyage<span>Bus</span></div>
        </a>

        <ul class="nav-menu">
            <li><a href="${pageContext.request.contextPath}/" class="nav-link ${currentNav == 'home' ? 'active' : ''}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/search" class="nav-link ${currentNav == 'search' ? 'active' : ''}">Book Tickets</a></li>
            <c:if test="${sessionScope.currentUser != null}">
                <li><a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link ${currentNav == 'my-bookings' ? 'active' : ''}">My Bookings</a></li>
            </c:if>
            <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.admin}">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${currentNav == 'admin' ? 'active' : ''}" style="color: var(--color-primary); font-weight: 700;">Admin Console</a></li>
            </c:if>
            <li><a href="${pageContext.request.contextPath}/about" class="nav-link ${currentNav == 'about' ? 'active' : ''}">About</a></li>
            <li><a href="${pageContext.request.contextPath}/contact" class="nav-link ${currentNav == 'contact' ? 'active' : ''}">Contact</a></li>
        </ul>

        <div class="nav-actions">
            <c:choose>
                <c:when test="${sessionScope.currentUser != null}">
                    <span style="font-size: 13px; font-weight: 600; color: var(--color-text);">
                        Hi, ${sessionScope.currentUser.fullName}
                    </span>
                    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline btn-sm">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline btn-sm">Login</a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary btn-sm">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
