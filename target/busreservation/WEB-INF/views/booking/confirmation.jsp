<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Booking Confirmed - VoyageBus Express" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 680px;">
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 40px; box-shadow: var(--shadow-md); text-align: center;">
            <div style="width: 64px; height: 64px; background-color: var(--color-success-bg); color: var(--color-success); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; margin: 0 auto 20px auto;">
                ✓
            </div>

            <h1 style="font-size: 26px; font-weight: 700; color: var(--color-text); margin-bottom: 8px;">Reservation Confirmed!</h1>
            <p style="font-size: 15px; color: var(--color-text-muted); margin-bottom: 24px;">
                Your bus tickets are booked. An electronic confirmation has been logged.
            </p>

            <div style="background-color: var(--color-primary-light); border: 1px dashed var(--color-primary); border-radius: var(--radius-md); padding: 18px; margin-bottom: 32px;">
                <div style="font-size: 12px; font-weight: 700; text-transform: uppercase; color: var(--color-primary); letter-spacing: 0.5px;">Booking Reference Number</div>
                <div style="font-size: 24px; font-weight: 800; color: var(--color-primary-dark); font-family: monospace; margin-top: 4px;">
                    ${booking.bookingReference}
                </div>
            </div>

            <div style="background-color: var(--color-bg-secondary); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 24px; text-align: left; margin-bottom: 32px;">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; font-size: 14px;">
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Lead Passenger</div>
                        <div style="font-weight: 600; color: var(--color-text);">${booking.passengerName}</div>
                    </div>
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Total Seats</div>
                        <div style="font-weight: 700; color: var(--color-primary);">${booking.totalSeats} (${booking.seatNumbersAsString})</div>
                    </div>
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Route</div>
                        <div style="font-weight: 600; color: var(--color-text);">${booking.schedule.route.sourceCity} &rarr; ${booking.schedule.route.destinationCity}</div>
                    </div>
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Departure Date & Time</div>
                        <div style="font-weight: 600; color: var(--color-text);">${booking.schedule.formattedJourneyDate}, ${booking.schedule.formattedDepartureTime}</div>
                    </div>
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Bus Service</div>
                        <div style="font-weight: 600; color: var(--color-text);">${booking.schedule.bus.busName}</div>
                    </div>
                    <div>
                        <div style="color: var(--color-text-muted); font-size: 12px; text-transform: uppercase;">Total Paid</div>
                        <div style="font-weight: 700; color: var(--color-text);">INR ${booking.totalFare}</div>
                    </div>
                </div>
            </div>

            <div style="display: flex; justify-content: center; gap: 16px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/booking/ticket/${booking.bookingReference}" class="btn btn-primary btn-lg">
                    View & Print Ticket
                </a>
                <a href="${pageContext.request.contextPath}/booking/my-bookings" class="btn btn-outline btn-lg">
                    My Bookings
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline btn-lg">
                    Book Another Journey
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
