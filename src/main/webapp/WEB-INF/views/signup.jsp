<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sign Up - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"/>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <main class="auth-wrap">
        <section class="card auth-card">
            <span class="eyebrow">Your next game starts here</span>
            <h1>Create your account</h1>
            <p class="subtitle">Keep your bookings in one place and get straight to the game.</p>

            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/signup" class="form-grid">
                <label>
                    <span>Full Name</span>
                    <input type="text" name="name" required placeholder="Your Name">
                </label>
                <label>
                    <span>Email</span>
                    <input type="email" name="email" required placeholder="you@example.com">
                </label>
                <label>
                    <span>Phone</span>
                    <input type="tel" name="phone" required placeholder="98765 43210">
                </label>
                <label>
                    <span>Password</span>
                    <input type="password" name="password" required minlength="8" maxlength="72" autocomplete="new-password" placeholder="At least 8 characters">
                </label>
                <button type="submit" class="btn-primary">Create account <span aria-hidden="true">→</span></button>
            </form>
            <p class="auth-aside">Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a></p>
        </section>
    </main>
</body>
</html>
