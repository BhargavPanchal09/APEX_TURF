<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Bookings - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"/>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <main class="container">
        <section class="card">
            <span class="eyebrow">Your game plan</span>
            <h1>My bookings</h1>
            <p class="subtitle">Your upcoming sessions and past games, all in one place.</p>

            <c:if test="${not empty successMessage}">
                <div class="alert success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert error">${errorMessage}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty bookings}">
                    <div class="table-scroll">
                    <table class="bookings-table">
                        <thead>
                        <tr>
                            <th>Turf</th>
                            <th>Sport</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bookings}" var="b">
                            <tr>
                                <td>${b.turfName}</td>
                                <td>${b.sportName}</td>
                                <td>${b.formattedStartTime}</td>
                                <td>${b.formattedEndTime}</td>
                                <td><span class="status-${b.status.toLowerCase()}">${b.status}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.cancellable}">
                                            <form method="post" action="${pageContext.request.contextPath}/my-bookings" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                <button type="submit" class="btn-cancel">Cancel</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${b.reviewable}">
                                            <a href="${pageContext.request.contextPath}/review?bookingId=${b.id}" class="btn-review">Leave a review</a>
                                        </c:when>
                                        <c:otherwise>
                                                    <span class="action-muted">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <span class="empty-state-icon" aria-hidden="true">⚽</span>
                        <h2>No bookings yet</h2>
                        <p>Your next game is one good slot away. Browse the available turfs and find a time that works.</p>
                        <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Find a turf <span aria-hidden="true">→</span></a>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
