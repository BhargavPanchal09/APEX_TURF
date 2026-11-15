<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="navbar">
    <a class="brand" href="${pageContext.request.contextPath}/booking" aria-label="Apex Turf home">
        <span class="brand-mark" aria-hidden="true">A</span>
        <span class="brand-name">APEX TURF<small>PLAY YOUR WAY</small></span>
    </a>
    <nav class="nav-links" aria-label="Main navigation">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <%-- User is Logged IN --%>
                <span class="nav-welcome">Hi, ${sessionScope.user.name}</span>

                <a href="${pageContext.request.contextPath}/booking"
                   class="nav-link ${currentPage == 'booking' ? 'active' : ''}">Book a Slot</a>

                <a href="${pageContext.request.contextPath}/my-bookings"
                   class="nav-link ${currentPage == 'my-bookings' ? 'active' : ''}">My Bookings</a>

                <%-- THIS IS THE NEW ADMIN-ONLY LOGIC --%>
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link nav-link-admin">Admin Panel</a>
                </c:if>

                <form class="nav-logout" method="post" action="${pageContext.request.contextPath}/logout"><button class="nav-link" type="submit">Log out</button></form>
            </c:when>
            <c:otherwise>
                <%-- User is Logged OUT --%>
                <a href="${pageContext.request.contextPath}/login" class="nav-link">Login</a>
                <a href="${pageContext.request.contextPath}/signup" class="nav-link">Sign Up</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>
