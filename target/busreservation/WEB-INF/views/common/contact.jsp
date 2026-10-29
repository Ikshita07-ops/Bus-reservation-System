<c:set var="pageTitle" value="Contact Us - VoyageBus Express" scope="request" />
<c:set var="currentNav" value="contact" scope="request" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="main-content">
    <div class="container" style="max-width: 800px;">
        <div style="background-color: #FFFFFF; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 40px; box-shadow: var(--shadow-sm);">
            <h1 style="font-size: 28px; font-weight: 700; color: var(--color-text); margin-bottom: 8px;">Contact <span style="color: var(--color-primary);">Customer Support</span></h1>
            <p style="font-size: 15px; color: var(--color-text-muted); margin-bottom: 32px;">
                Have questions regarding your reservation, cancellation, or schedule? We are available 24/7.
            </p>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 36px;">
                <div style="padding: 20px; border: 1px solid var(--color-border); border-radius: var(--radius-md); background-color: var(--color-bg-secondary);">
                    <div style="font-weight: 700; font-size: 16px; margin-bottom: 6px; color: var(--color-primary);">Toll-Free Helpline</div>
                    <div style="font-size: 18px; font-weight: 700; color: var(--color-text);">1800 200 4567</div>
                    <div style="font-size: 13px; color: var(--color-text-muted); margin-top: 4px;">Available 24 hours a day, 7 days a week</div>
                </div>
                <div style="padding: 20px; border: 1px solid var(--color-border); border-radius: var(--radius-md); background-color: var(--color-bg-secondary);">
                    <div style="font-weight: 700; font-size: 16px; margin-bottom: 6px; color: var(--color-primary);">Email Support</div>
                    <div style="font-size: 18px; font-weight: 700; color: var(--color-text);">support@voyagebus.com</div>
                    <div style="font-size: 13px; color: var(--color-text-muted); margin-top: 4px;">Response guaranteed within 30 minutes</div>
                </div>
            </div>

            <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 16px;">Corporate Head Office</h3>
            <p style="font-size: 15px; color: var(--color-text); line-height: 1.6;">
                VoyageBus Express Mobility Solutions Pvt. Ltd.<br>
                Plot No. 42, Cyber Gateway, HITEC City,<br>
                Hyderabad, Telangana - 500081, India
            </p>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
