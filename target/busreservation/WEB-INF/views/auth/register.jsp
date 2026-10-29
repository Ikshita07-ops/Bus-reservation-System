<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Account - VoyageBus Express" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 480px;">
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 36px; box-shadow: var(--shadow-md);">
            <div style="text-align: center; margin-bottom: 24px;">
                <h1 style="font-size: 24px; font-weight: 700; color: var(--color-text);">Create New Account</h1>
                <p style="font-size: 14px; color: var(--color-text-muted); margin-top: 4px;">Sign up to book bus tickets quickly and manage your reservations</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/register" method="POST" id="regForm">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="regFullName">Full Name</label>
                    <input type="text" id="regFullName" name="fullName" value="${user.fullName}" class="form-control" placeholder="e.g. John Doe" required />
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="regEmail">Email Address</label>
                    <input type="email" id="regEmail" name="email" value="${user.email}" class="form-control" placeholder="name@example.com" required />
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" for="regPhone">Phone Number</label>
                    <input type="tel" id="regPhone" name="phone" value="${user.phone}" class="form-control" placeholder="+91 9876543210" required />
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="regPassword">Password (Minimum 6 characters)</label>
                    <input type="password" id="regPassword" name="password" minlength="6" class="form-control" placeholder="Create a strong password" required />
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-bottom: 20px;">
                    Create Account
                </button>
            </form>

            <div style="text-align: center; font-size: 14px; color: var(--color-text-muted);">
                Already have an account? <a href="${pageContext.request.contextPath}/auth/login" style="font-weight: 600;">Sign In</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
