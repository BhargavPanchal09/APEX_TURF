<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#10140f">
    <meta name="description" content="Find a turf, check the schedule and book your next game with Apex Turf.">
    <title>APEX TURF — Make room for your game</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="landing-page">
    <section class="landing-hero">
        <div class="landing-copy">
            <span class="eyebrow"><span class="live-dot"></span> Your game, your time</span>
            <h1>Make room<br>for <em>your game.</em></h1>
            <p>Find a local turf, see when it’s open, and get your team together. A better game starts with an easier booking.</p>
            <div class="landing-actions">
                <a class="btn-primary" href="${pageContext.request.contextPath}/booking">Find a turf <span aria-hidden="true">→</span></a>
                <c:if test="${empty sessionScope.user}">
                    <a class="landing-secondary" href="${pageContext.request.contextPath}/signup">Create an account</a>
                </c:if>
            </div>
            <div class="landing-trust"><span class="trust-icon" aria-hidden="true">✓</span> Live availability <span class="trust-separator">·</span> Easy reservations</div>
        </div>
        <div class="field-art" aria-label="Illustration of a sports field">
            <div class="field-frame"><div class="field-lines"><span class="field-center"></span><span class="field-box field-box-left"></span><span class="field-box field-box-right"></span><span class="field-goal field-goal-left"></span><span class="field-goal field-goal-right"></span></div><span class="field-ball">⚽</span></div>
            <div class="field-note"><span class="field-note-icon">✦</span><span><strong>Game on</strong><small>Your next slot is waiting</small></span></div>
        </div>
        <div class="landing-orbit landing-orbit-one"></div>
        <div class="landing-orbit landing-orbit-two"></div>
    </section>
    <section class="landing-features" aria-labelledby="features-title">
        <div class="section-heading">
            <span class="eyebrow">From plan to kickoff</span>
            <h2 id="features-title">Everything you need to get out and play.</h2>
        </div>
        <div class="feature-grid">
            <article class="feature-card"><span class="feature-number">01</span><span class="feature-icon" aria-hidden="true">⌕</span><h3>Find your turf</h3><p>Browse available grounds and see which sports each one supports.</p></article>
            <article class="feature-card"><span class="feature-number">02</span><span class="feature-icon" aria-hidden="true">◷</span><h3>Pick your time</h3><p>Check the calendar before you book, so your team knows when to show up.</p></article>
            <article class="feature-card"><span class="feature-number">03</span><span class="feature-icon" aria-hidden="true">↗</span><h3>Keep the game going</h3><p>Manage reservations and share your experience after the final whistle.</p></article>
        </div>
    </section>
    <section class="landing-cta">
        <div><span class="eyebrow">Your next game is closer than you think</span><h2>Ready to get on the field?</h2></div>
        <a class="btn-primary" href="${pageContext.request.contextPath}/booking">Explore turfs <span aria-hidden="true">→</span></a>
    </section>
</main>
<footer class="site-footer"><a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark" aria-hidden="true">A</span><span class="brand-name">APEX TURF<small>PLAY YOUR WAY</small></span></a><span>Find a field. Bring your people. Play.</span></footer>
</body>
</html>
