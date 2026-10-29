<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign In - VoyageBus Express" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 460px;">
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 36px; box-shadow: var(--shadow-md);">
            <div style="text-align: center; margin-bottom: 28px;">
                <div class="brand-logo" style="margin: 0 auto 12px auto;">V</div>
                <h1 style="font-size: 24px; font-weight: 700; color: var(--color-text);">Welcome Back</h1>
                <p style="font-size: 14px; color: var(--color-text-muted); margin-top: 4px;">Sign in to access your bookings and travel preferences</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <span>${errorMessage}</span>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <span>${successMessage}</span>
                </div>
            </c:if>
            <c:if test="${not empty infoMessage}">
                <div class="alert alert-info">
                    <span>${infoMessage}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                <input type="hidden" name="redirect" value="${redirect}" />

                <div class="form-group" style="margin-bottom: 18px;">
                    <label class="form-label" for="loginEmail">Email Address</label>
                    <input type="email" id="loginEmail" name="email" class="form-control" placeholder="name@example.com" required autofocus />
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label class="form-label" for="loginPassword">Password</label>
                    <input type="password" id="loginPassword" name="password" class="form-control" placeholder="Enter your password" required />
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-bottom: 20px;">
                    Sign In
                </button>
            </form>

            <!-- Quick Demo Credentials Box -->
            <div style="background-color: var(--color-bg-secondary); border: 1px dashed var(--color-border-dark); border-radius: var(--radius-md); padding: 14px; font-size: 12px; margin-bottom: 20px;">
                <div style="font-weight: 700; color: var(--color-text); margin-bottom: 6px;">Demo Test Credentials:</div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                    <span><strong>Admin:</strong> admin@busreservation.com</span>
                    <button type="button" class="btn btn-outline-primary btn-sm" onclick="fillCreds('admin@busreservation.com', 'admin123')">Fill Admin</button>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span><strong>Customer:</strong> john.doe@example.com</span>
                    <button type="button" class="btn btn-outline-primary btn-sm" onclick="fillCreds('john.doe@example.com', 'password123')">Fill Customer</button>
                </div>
            </div>

            <div style="text-align: center; font-size: 14px; color: var(--color-text-muted);">
                Don't have an account? <a href="${pageContext.request.contextPath}/auth/register" style="font-weight: 600;">Create Account</a>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(email, pwd) {
    document.getElementById('loginEmail').value = email;
    document.getElementById('loginPassword').value = pwd;
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
