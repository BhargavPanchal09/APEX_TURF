<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${turf.name} - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.13/index.global.min.js"></script>
    <style>
        .review-card { border: 1px solid var(--border-color); border-radius: 8px; padding: 16px; margin-bottom: 16px; }
        .review-header { display: flex; justify-content: space-between; align-items: center; }
        .review-user { font-weight: bold; }
        .review-stars, .avg-rating-value { color: #f59e0b; }
        .review-comment { margin-top: 8px; color: var(--muted); }
        .avg-rating-box { text-align: center; margin: 1rem 0 2rem; }
        .avg-rating-value { font-size: 3rem; font-weight: bold; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="container">
    <section class="card">
        <h1>${turf.name}</h1>
        <p class="subtitle">${turf.location} <span class="detail-separator">·</span> <strong class="turf-rate">&#8377;<fmt:formatNumber value="${turf.hourlyRate}" minFractionDigits="0" maxFractionDigits="2"/> / hour</strong></p>
        <h2>Availability</h2>
        <p class="subtitle">Select an open time to start a booking.</p>
        <div id="calendar-error" class="alert error" role="alert" hidden></div>
        <div id="booking-calendar"></div>
        <div class="avg-rating-box">
            <div class="avg-rating-value"><fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/></div>
            <div class="review-stars">
                <c:forEach begin="1" end="5" var="star"><c:choose><c:when test="${star <= averageRating}">&#9733;</c:when><c:otherwise>&#9734;</c:otherwise></c:choose></c:forEach>
            </div>
            <p class="subtitle">Average rating</p>
        </div>
        <h2>Recent reviews</h2>
        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach items="${reviews}" var="review">
                    <article class="review-card">
                        <div class="review-header">
                            <span class="review-user"><c:out value="${review.userName}"/></span>
                            <span class="review-stars"><c:forEach begin="1" end="5" var="star"><c:choose><c:when test="${star <= review.rating}">&#9733;</c:when><c:otherwise>&#9734;</c:otherwise></c:choose></c:forEach></span>
                        </div>
                        <p class="review-comment"><c:out value="${review.comment}"/></p>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise><p class="subtitle">No reviews yet.</p></c:otherwise>
        </c:choose>
    </section>
</main>
<div id="booking-modal" class="modal-overlay">
    <div class="modal-content">
        <h2>Book at ${turf.name}</h2>
        <div id="modal-error" class="alert error" style="display:none"></div>
        <form id="modal-booking-form">
            <input type="hidden" name="turfId" value="${turf.id}">
            <label><span>Sport</span><select name="sportId" required>
                <c:forEach items="${sports}" var="sport"><c:if test="${turf.sportIds.contains(sport.id)}"><option value="${sport.id}">${sport.name}</option></c:if></c:forEach>
            </select></label>
            <label><span>Start time</span><input type="datetime-local" name="startTime" required></label>
            <label><span>End time</span><input type="datetime-local" name="endTime" required></label>
            <div class="modal-actions"><button type="button" id="modal-close-btn" class="btn-secondary">Close</button><button type="submit" class="btn-primary">Confirm booking</button></div>
        </form>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const contextPath = '${pageContext.request.contextPath}';
    const calendarEl = document.getElementById('booking-calendar');
    if (!window.FullCalendar) {
        calendarEl.textContent = 'The schedule could not load. Check your connection and refresh this page.';
        return;
    }
    const modal = document.getElementById('booking-modal');
    const form = document.getElementById('modal-booking-form');
    const errorBox = document.getElementById('modal-error');
    const calendar = new FullCalendar.Calendar(document.getElementById('booking-calendar'), {
        initialView: 'timeGridWeek',
        headerToolbar: { left: 'prev,next today', center: 'title', right: 'timeGridWeek,timeGridDay' },
        slotMinTime: '06:00:00', slotMaxTime: '24:00:00', allDaySlot: false,
        events: function(info, success, failure) {
            const query = new URLSearchParams({ turfId: '${turf.id}', start: info.startStr, end: info.endStr });
            fetch(contextPath + '/api/bookings?' + query).then(r => r.ok ? r.json() : Promise.reject(r)).then(data => { document.getElementById('calendar-error').hidden = true; success(data); }).catch(error => { const message = document.getElementById('calendar-error'); message.textContent = 'Availability could not be loaded. Please refresh to try again.'; message.hidden = false; failure(error); });
        },
        eventColor: '#dc2626',
        dateClick: function(info) {
            if (info.date < new Date()) return;
            const start = info.date;
            const end = new Date(start.getTime() + 60 * 60 * 1000);
            form.elements.startTime.value = toLocalISOString(start);
            form.elements.endTime.value = toLocalISOString(end);
            errorBox.style.display = 'none';
            modal.style.display = 'flex';
        }
    });
    calendar.render();
    document.getElementById('modal-close-btn').addEventListener('click', () => modal.style.display = 'none');
    modal.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        fetch(contextPath + '/booking', { method: 'POST', body: new URLSearchParams(new FormData(form)) })
            .then(r => r.json())
            .then(data => {
                if (data.success) { modal.style.display = 'none'; calendar.refetchEvents(); }
                else { errorBox.textContent = data.message; errorBox.style.display = 'block'; }
            })
            .catch(() => { errorBox.textContent = 'Could not submit the booking. Please try again.'; errorBox.style.display = 'block'; });
    });
});
function toLocalISOString(date) {
    const offset = date.getTimezoneOffset() * 60000;
    return new Date(date - offset).toISOString().slice(0, 16);
}
</script>
</body>
</html>
