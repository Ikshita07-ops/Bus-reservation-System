<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Search Results - VoyageBus Express" scope="request" />
<c:set var="currentNav" value="search" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container">
        <!-- Search Modification Bar -->
        <div class="search-card" style="margin-bottom: 28px; padding: 20px;">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form">
                <div class="form-group">
                    <label class="form-label" for="resSource">Departure City</label>
                    <select id="resSource" name="source" class="form-control">
                        <option value="">All departure cities</option>
                        <c:forEach items="${sources}" var="src">
                            <option value="${src}" ${criteria.source == src ? 'selected' : ''}>${src}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="resDestination">Arrival City</label>
                    <select id="resDestination" name="destination" class="form-control">
                        <option value="">All arrival cities</option>
                        <c:forEach items="${destinations}" var="dst">
                            <option value="${dst}" ${criteria.destination == dst ? 'selected' : ''}>${dst}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="resJourneyDate">Date of Journey</label>
                    <input type="date" id="resJourneyDate" name="journeyDate" value="${criteria.journeyDate}" min="${today}" class="form-control" />
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="height: 48px;">
                    Update Search
                </button>
            </form>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <div class="search-results-layout">
            <!-- Sidebar Filters -->
            <div class="filter-card">
                <div class="filter-title">Filter Buses</div>

                <div class="filter-group">
                    <div class="filter-group-label">Bus Category</div>
                    <label class="checkbox-label">
                        <input type="checkbox" class="bus-type-filter" value="AC Sleeper" onchange="filterBuses()" />
                        AC Sleeper
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" class="bus-type-filter" value="Volvo" onchange="filterBuses()" />
                        Volvo Multi-Axle
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" class="bus-type-filter" value="Seater" onchange="filterBuses()" />
                        Luxury Seater
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" class="bus-type-filter" value="Non-AC" onchange="filterBuses()" />
                        Non-AC Classic
                    </label>
                </div>

                <div class="filter-group">
                    <div class="filter-group-label">Departure Time</div>
                    <label class="checkbox-label">
                        <input type="checkbox" class="time-filter" value="morning" onchange="filterBuses()" />
                        Morning (06:00 - 12:00)
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" class="time-filter" value="afternoon" onchange="filterBuses()" />
                        Afternoon (12:00 - 18:00)
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" class="time-filter" value="night" onchange="filterBuses()" />
                        Night (18:00 - 06:00)
                    </label>
                </div>

                <button type="button" class="btn btn-outline btn-sm btn-block" onclick="resetFilters()">
                    Reset Filters
                </button>
            </div>

            <!-- Bus Results Column -->
            <div>
                <div class="section-header" style="margin-bottom: 16px;">
                    <div>
                        <h2 class="section-title">
                            <c:choose>
                                <c:when test="${not empty criteria.source && not empty criteria.destination}">
                                    ${criteria.source} to ${criteria.destination}
                                </c:when>
                                <c:otherwise>
                                    Available Bus Schedules
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="section-subtitle">
                            Found ${schedules.size()} verified journeys for ${criteria.journeyDate}
                        </p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty schedules}">
                        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 48px; text-align: center;">
                            <div style="font-size: 40px; margin-bottom: 12px; color: var(--color-primary);">🚌</div>
                            <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">No scheduled buses found</h3>
                            <p style="color: var(--color-text-muted); font-size: 14px; margin-bottom: 24px; max-width: 440px; margin-left: auto; margin-right: auto;">
                                There are no active journeys matching your selected cities or date. Try choosing another journey date or browse all popular intercity routes.
                            </p>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">View All Available Schedules</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bus-list" id="busListContainer">
                            <c:forEach items="${schedules}" var="s">
                                <div class="bus-card" data-bustype="${s.bus.busType}" data-time="${s.departureTime}">
                                    <div class="bus-card-header">
                                        <div>
                                            <div class="bus-info-name">${s.bus.busName}</div>
                                            <div class="bus-info-type">${s.bus.busType} • ${s.bus.busNumber}</div>
                                        </div>

                                        <div class="bus-time-wrapper">
                                            <div class="time-box">
                                                <div class="time-val">${s.formattedDepartureTime}</div>
                                                <div class="time-city">${s.route.sourceCity}</div>
                                            </div>

                                            <div class="duration-line">
                                                ${s.route.estimatedDuration}
                                            </div>

                                            <div class="time-box">
                                                <div class="time-val">${s.formattedArrivalTime}</div>
                                                <div class="time-city">${s.route.destinationCity}</div>
                                            </div>
                                        </div>

                                        <div class="bus-fare-col">
                                            <div class="bus-fare-amount">INR ${s.fare}</div>
                                            <c:choose>
                                                <c:when test="${s.availableSeats > 0}">
                                                    <span class="bus-seat-badge">${s.availableSeats} Seats Available</span>
                                                    <a href="${pageContext.request.contextPath}/search/seat-layout/${s.id}" class="btn btn-primary btn-sm" style="margin-top: 4px;">
                                                        Select Seats
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Sold Out</span>
                                                    <button class="btn btn-outline btn-sm" disabled style="opacity: 0.6; cursor: not-allowed; margin-top: 4px;">
                                                        Full
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="bus-card-footer">
                                        <div>
                                            <strong>Amenities:</strong> ${not empty s.bus.amenities ? s.bus.amenities : 'Standard Comfort, Reading Light'}
                                        </div>
                                        <div>
                                            Journey Date: <strong>${s.formattedJourneyDate}</strong>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
function filterBuses() {
    var typeChecks = Array.from(document.querySelectorAll('.bus-type-filter:checked')).map(c => c.value.toLowerCase());
    var timeChecks = Array.from(document.querySelectorAll('.time-filter:checked')).map(c => c.value);
    var cards = document.querySelectorAll('.bus-card');

    cards.forEach(function(card) {
        var busType = (card.getAttribute('data-bustype') || '').toLowerCase();
        var depTime = card.getAttribute('data-time') || '';
        var hour = parseInt(depTime.split(':')[0], 10);

        var matchesType = typeChecks.length === 0 || typeChecks.some(t => busType.includes(t));
        var matchesTime = timeChecks.length === 0;

        if (timeChecks.length > 0) {
            for (var i = 0; i < timeChecks.length; i++) {
                var t = timeChecks[i];
                if (t === 'morning' && hour >= 6 && hour < 12) matchesTime = true;
                if (t === 'afternoon' && hour >= 12 && hour < 18) matchesTime = true;
                if (t === 'night' && (hour >= 18 || hour < 6)) matchesTime = true;
            }
        }

        if (matchesType && matchesTime) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

function resetFilters() {
    document.querySelectorAll('.bus-type-filter, .time-filter').forEach(c => c.checked = false);
    document.querySelectorAll('.bus-card').forEach(c => c.style.display = 'block');
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
