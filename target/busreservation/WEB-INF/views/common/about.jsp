<c:set var="pageTitle" value="About Us - VoyageBus Express" scope="request" />
<c:set var="currentNav" value="about" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 800px;">
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 40px; box-shadow: var(--shadow-sm);">
            <h1 style="font-size: 28px; font-weight: 700; color: var(--color-text); margin-bottom: 16px;">About <span style="color: var(--color-primary);">VoyageBus Express</span></h1>
            <p style="font-size: 16px; color: var(--color-text-muted); line-height: 1.8; margin-bottom: 24px;">
                VoyageBus Express is an enterprise bus ticket reservation and fleet management system built with robust Java, Spring MVC, Hibernate ORM, and MySQL technology. We pride ourselves on offering seamless intercity bus booking, real-time seat tracking, and instant electronic boarding passes.
            </p>
            <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 12px; color: var(--color-text);">Why Choose VoyageBus?</h3>
            <ul style="margin-left: 20px; line-height: 2; color: var(--color-text); font-size: 15px; margin-bottom: 24px;">
                <li><strong>Real-Time Seat Availability:</strong> Guaranteed no double bookings with concurrency-safe database transactions.</li>
                <li><strong>Transparent Pricing:</strong> No hidden booking fees or sudden convenience charge surprises.</li>
                <li><strong>Instant Cancellation & Seat Release:</strong> Cancel eligible tickets with one click; seats are immediately restored to the live booking pool.</li>
                <li><strong>Verified Fleet Partners:</strong> State-of-the-art Volvo, Scania, and BharatBenz coaches maintained to high safety standards.</li>
            </ul>
            <div style="border-top: 1px solid var(--color-border); padding-top: 20px; display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Find a Bus Journey</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">Contact Support</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
