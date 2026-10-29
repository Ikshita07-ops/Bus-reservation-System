<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Checkout & Passenger Details - VoyageBus Express" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 960px;">
        <div style="margin-bottom: 24px;">
            <a href="${pageContext.request.contextPath}/search/seat-layout/${schedule.id}" style="font-size: 13px; font-weight: 600; color: var(--color-primary); display: inline-block; margin-bottom: 8px;">
                &larr; Change Seat Selection
            </a>
            <h1 style="font-size: 26px; font-weight: 700; color: var(--color-text);">Confirm Booking & Passenger Details</h1>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking/confirm" method="POST">
            <input type="hidden" name="scheduleId" value="${schedule.id}" />

            <div style="display: grid; grid-template-columns: 1fr 340px; gap: 24px;">
                <!-- Left: Passenger Information -->
                <div>
                    <!-- Primary Contact Info Card -->
                    <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm); margin-bottom: 24px;">
                        <h3 style="font-size: 17px; font-weight: 700; color: var(--color-text); margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--color-border);">
                            1. Primary Contact Information
                        </h3>
                        <p style="font-size: 13px; color: var(--color-text-muted); margin-bottom: 18px;">
                            Your e-ticket and booking reference will be sent to these contact details.
                        </p>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label" for="primaryName">Lead Passenger Name</label>
                            <input type="text" id="primaryName" name="passengerName" value="${currentUser.fullName}" class="form-control" placeholder="Full legal name" required />
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="form-group">
                                <label class="form-label" for="primaryEmail">Email Address</label>
                                <input type="email" id="primaryEmail" name="passengerEmail" value="${currentUser.email}" class="form-control" placeholder="name@example.com" required />
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="primaryPhone">Phone Number</label>
                                <input type="tel" id="primaryPhone" name="passengerPhone" value="${currentUser.phone}" class="form-control" placeholder="+91 9876543210" required />
                            </div>
                        </div>
                    </div>

                    <!-- Passenger Seat Specific Details -->
                    <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 17px; font-weight: 700; color: var(--color-text); margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--color-border);">
                            2. Passenger Seat Allocation
                        </h3>

                        <c:forEach items="${selectedSeats}" var="seat" varStatus="status">
                            <input type="hidden" name="seatNumbers" value="${seat}" />
                            <div style="background-color: var(--color-bg-secondary); border: 1px solid var(--color-border); border-radius: var(--radius-sm); padding: 16px; margin-bottom: 16px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <span style="font-weight: 700; font-size: 15px; color: var(--color-text);">
                                        Seat ${seat}
                                    </span>
                                    <span style="font-size: 13px; font-weight: 600; color: var(--color-primary);">
                                        INR ${schedule.fare}
                                    </span>
                                </div>

                                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 12px;">
                                    <div class="form-group">
                                        <label class="form-label">Passenger Label</label>
                                        <input type="text" class="form-control" value="Passenger ${status.index + 1} (Seat ${seat})" readonly style="background-color: #EEEEEE;" />
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Gender</label>
                                        <select name="gender_${seat}" class="form-control">
                                            <option value="MALE">Male</option>
                                            <option value="FEMALE">Female</option>
                                            <option value="OTHER">Other</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Right: Payment & Final Summary -->
                <div>
                    <div class="summary-card">
                        <h3 class="summary-title">Fare Breakdown</h3>

                        <div class="summary-row">
                            <span style="color: var(--color-text-muted);">Journey:</span>
                            <span style="font-weight: 600;">${schedule.route.sourceCity} &rarr; ${schedule.route.destinationCity}</span>
                        </div>
                        <div class="summary-row">
                            <span style="color: var(--color-text-muted);">Bus:</span>
                            <span style="font-weight: 600;">${schedule.bus.busName}</span>
                        </div>
                        <div class="summary-row">
                            <span style="color: var(--color-text-muted);">Date & Time:</span>
                            <span style="font-weight: 600;">${schedule.formattedJourneyDate}, ${schedule.formattedDepartureTime}</span>
                        </div>
                        <div class="summary-row">
                            <span style="color: var(--color-text-muted);">Seats Selected:</span>
                            <span style="font-weight: 700; color: var(--color-primary);">${selectedSeats.size()} (${selectedSeats})</span>
                        </div>

                        <div class="summary-row total">
                            <span>Total Amount:</span>
                            <span>INR ${totalFare}</span>
                        </div>

                        <div style="background-color: var(--color-success-bg); border: 1px solid #C8E6C9; border-radius: var(--radius-sm); padding: 12px; font-size: 12px; color: #1B5E20; margin-top: 20px;">
                            ✓ Free cancellation available up to bus departure time. Immediate seat release guarantee.
                        </div>

                        <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 24px;">
                            Confirm & Complete Booking
                        </button>

                        <div style="font-size: 12px; color: var(--color-text-muted); text-align: center; margin-top: 12px;">
                            By clicking confirm, you agree to VoyageBus travel terms.
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
