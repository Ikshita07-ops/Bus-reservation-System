<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Ticket - ${booking.bookingReference}" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; max-width: 760px; margin: 0 auto 20px auto;" class="no-print">
            <a href="${pageContext.request.contextPath}/booking/my-bookings" class="btn btn-outline btn-sm">
                &larr; Back to My Bookings
            </a>
            <div style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-primary btn-sm" onclick="window.print()">
                    🖨 Print Ticket
                </button>
            </div>
        </div>

        <div class="ticket-wrapper">
            <div class="ticket-header">
                <div>
                    <h2>VoyageBus Express</h2>
                    <div style="font-size: 13px; opacity: 0.9;">Official Electronic Boarding Pass</div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 11px; text-transform: uppercase; letter-spacing: 1px; opacity: 0.8;">Status</div>
                    <span class="badge ${booking.confirmed ? 'badge-success' : 'badge-danger'}" style="font-size: 13px; font-weight: 700; background-color: #FFFFFF; color: ${booking.confirmed ? '#1B5E20' : '#B71C1C'};">
                        ${booking.bookingStatus}
                    </span>
                </div>
            </div>

            <div class="ticket-body">
                <!-- Reference Strip -->
                <div style="display: flex; justify-content: space-between; align-items: center; background-color: var(--color-bg-secondary); border: 1px solid var(--color-border); border-radius: var(--radius-sm); padding: 12px 18px; margin-bottom: 24px;">
                    <div>
                        <div class="ticket-field-label">Booking Reference</div>
                        <div style="font-size: 18px; font-weight: 700; font-family: monospace; color: var(--color-primary);">${booking.bookingReference}</div>
                    </div>
                    <div>
                        <div class="ticket-field-label">Booked On</div>
                        <div class="ticket-field-value">${booking.formattedBookingDate}</div>
                    </div>
                    <div>
                        <div class="ticket-field-label">Total Seats</div>
                        <div style="font-size: 18px; font-weight: 700; color: var(--color-text);">${booking.totalSeats} Seat(s)</div>
                    </div>
                </div>

                <!-- Journey Grid -->
                <div class="ticket-grid">
                    <div>
                        <div class="ticket-field-label">Departure From</div>
                        <div class="ticket-field-value" style="font-size: 18px;">${booking.schedule.route.sourceCity}</div>
                        <div style="font-size: 13px; color: var(--color-text-muted);">${booking.schedule.formattedDepartureTime}</div>
                        <div style="font-size: 12px; color: var(--color-text-muted);">${booking.schedule.formattedJourneyDate}</div>
                    </div>

                    <div style="text-align: center; display: flex; flex-direction: column; justify-content: center;">
                        <div style="font-size: 12px; color: var(--color-text-muted);">${booking.schedule.route.estimatedDuration}</div>
                        <div style="font-size: 20px; color: var(--color-primary); margin: 4px 0;">&xrarr;</div>
                        <div style="font-size: 11px; color: var(--color-text-muted);">${booking.schedule.route.distanceKm} km</div>
                    </div>

                    <div style="text-align: right;">
                        <div class="ticket-field-label">Arrival At</div>
                        <div class="ticket-field-value" style="font-size: 18px;">${booking.schedule.route.destinationCity}</div>
                        <div style="font-size: 13px; color: var(--color-text-muted);">${booking.schedule.formattedArrivalTime}</div>
                        <div style="font-size: 12px; color: var(--color-text-muted);">${booking.schedule.formattedJourneyDate}</div>
                    </div>
                </div>

                <div class="ticket-divider"></div>

                <!-- Bus and Passenger Details -->
                <div class="ticket-grid">
                    <div>
                        <div class="ticket-field-label">Bus Operator & Model</div>
                        <div class="ticket-field-value">${booking.schedule.bus.busName}</div>
                        <div style="font-size: 13px; color: var(--color-text-muted);">${booking.schedule.bus.busType}</div>
                    </div>
                    <div>
                        <div class="ticket-field-label">Vehicle Registration</div>
                        <div class="ticket-field-value">${booking.schedule.bus.busNumber}</div>
                    </div>
                    <div>
                        <div class="ticket-field-label">Reserved Seat Numbers</div>
                        <div style="font-size: 18px; font-weight: 700; color: var(--color-primary);">
                            ${booking.seatNumbersAsString}
                        </div>
                    </div>
                </div>

                <!-- Passenger Details Table -->
                <div style="margin-top: 16px;">
                    <div class="ticket-field-label" style="margin-bottom: 8px;">Passenger Allocation</div>
                    <table style="width: 100%; border-collapse: collapse; font-size: 13px; border: 1px solid var(--color-border);">
                        <thead>
                            <tr style="background-color: var(--color-bg-secondary);">
                                <th style="padding: 8px 12px; text-align: left; border-bottom: 1px solid var(--color-border);">Seat No</th>
                                <th style="padding: 8px 12px; text-align: left; border-bottom: 1px solid var(--color-border);">Passenger Name</th>
                                <th style="padding: 8px 12px; text-align: left; border-bottom: 1px solid var(--color-border);">Gender</th>
                                <th style="padding: 8px 12px; text-align: right; border-bottom: 1px solid var(--color-border);">Fare</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${booking.seats}" var="st">
                                <tr>
                                    <td style="padding: 8px 12px; border-bottom: 1px solid var(--color-border); font-weight: 700;">Seat ${st.seatNumber}</td>
                                    <td style="padding: 8px 12px; border-bottom: 1px solid var(--color-border);">${booking.passengerName}</td>
                                    <td style="padding: 8px 12px; border-bottom: 1px solid var(--color-border);">${st.passengerGender}</td>
                                    <td style="padding: 8px 12px; border-bottom: 1px solid var(--color-border); text-align: right;">INR ${st.seatFare}</td>
                                </tr>
                            </c:forEach>
                            <tr style="font-weight: 700; background-color: #FAFAFA;">
                                <td colspan="3" style="padding: 10px 12px; text-align: right;">Total Amount Paid:</td>
                                <td style="padding: 10px 12px; text-align: right; color: var(--color-primary); font-size: 15px;">INR ${booking.totalFare}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="ticket-divider"></div>

                <!-- Barcode Simulation and Terms -->
                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                    <div style="font-size: 11px; color: var(--color-text-muted); line-height: 1.6; max-width: 480px;">
                        <strong>Important Travel Guidelines:</strong><br>
                        • Please report at the boarding point at least 15 minutes before the departure time.<br>
                        • Carry a valid government photo ID along with this printed ticket or SMS ticket.<br>
                        • For queries, contact VoyageBus Helpline: 1800 200 4567 or support@voyagebus.com.
                    </div>

                    <!-- Simulated Barcode -->
                    <div style="text-align: center;">
                        <div style="font-family: monospace; letter-spacing: 3px; font-size: 24px; font-weight: 900; color: #333;">
                            ||||| | |||| || ||| | |||
                        </div>
                        <div style="font-size: 10px; color: var(--color-text-muted); font-family: monospace;">
                            ${booking.bookingReference}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
