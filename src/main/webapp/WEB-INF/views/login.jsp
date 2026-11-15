<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"/>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <main class="auth-wrap">
        <section class="card auth-card">
            <span class="eyebrow">Welcome back</span>
            <h1>Get back in the game.</h1>
            <p class="subtitle">Log in to book your next session and manage your reservations.</p>

            <c:if test="${param.success == 'true'}">
                <div class="alert success">Registration successful! Please log in.</div>
            </c:if>
            <c:if test="${param.logout == 'true'}">
                <div class="alert success">You have been logged out successfully.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/login" class="form-grid">
                <input type="hidden" name="next" value="${param.next}">
                <label style="grid-column: 1 / -1;">
                    <span>Email</span>
                    <input type="email" name="email" required autocomplete="email" placeholder="you@example.com">
                </label>
                <label style="grid-column: 1 / -1;">
                    <span>Password</span>
                    <input type="password" name="password" required autocomplete="current-password" placeholder="Your password">
                </label>
                <button type="submit" class="btn-primary">Log in <span aria-hidden="true">→</span></button>
            </form>
            <p class="auth-aside">New to Apex Turf? <a href="${pageContext.request.contextPath}/signup">Create an account</a></p>
        </section>
    </main>
</body>
</html>
