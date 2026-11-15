<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Book a Slot - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"/>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.13/index.global.min.js'></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <main class="container">
        <section class="booking-hero card">
            <span class="eyebrow">Find your field · Play your game</span>
            <h1>Good games start<br>with a great pitch.</h1>
            <p class="subtitle">Pick a turf, check its live schedule, and lock in a time that works for your team.</p>
            <c:if test="${empty sessionScope.user}">
                <a class="btn-primary" href="${pageContext.request.contextPath}/signup">Join Apex Turf <span aria-hidden="true">→</span></a>
            </c:if>
        </section>
        <section class="card booking-workspace" aria-labelledby="availability-title">
            <div class="section-heading" style="margin-top:0">
                <span class="eyebrow">Availability</span>
                <h2 id="availability-title">Find a time to play</h2>
                <p>Booked times are marked on the calendar. Select an open time to reserve it.</p>
            </div>
            <c:if test="${not empty success}"><div class="alert success">${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert error">${error}</div></c:if>
            <c:if test="${not empty sessionScope.error}"><div class="alert error">${sessionScope.error}</div><c:remove var="error" scope="session"/></c:if>

            <div class="turf-selection-group">
                <label>
                    <span>Choose a turf</span>
                    <select name="turfId" id="turf-select" required>
                        <c:forEach items="${turfs}" var="t">
                            <option value="${t.id}" ${t.id == initialTurfId ? 'selected' : ''}>${t.name} — ${t.location} · &#8377;<fmt:formatNumber value="${t.hourlyRate}" minFractionDigits="0" maxFractionDigits="2"/>/hr</option>
                        </c:forEach>
                    </select>
                </label>
                <a href="#" id="view-details-btn" class="btn-secondary">Turf details <span aria-hidden="true">↗</span></a>
            </div>

            <div id="calendar-error" class="alert error" role="alert" hidden></div>
            <div id="booking-calendar" aria-label="Turf booking calendar"></div>
        </section>
    </main>

    <div id="booking-modal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="modal-title">
        <div class="modal-content">
            <h2 id="modal-title">Book Slot</h2>
            <div id="modal-error" class="alert error" style="display:none;"></div>
            <form id="modal-booking-form">
                <input type="hidden" id="modal-turf-id" name="turfId">
                <label><span>Sport</span>
                    <select id="modal-sport-id" name="sportId" required>
                        <c:forEach items="${sports}" var="sport"><option value="${sport.id}">${sport.name}</option></c:forEach>
                    </select>
                </label>
                <label><span>Start time</span><input type="datetime-local" id="modal-start-time" name="startTime" required/></label>
                <label><span>End time</span><input type="datetime-local" id="modal-end-time" name="endTime" required/></label>
                <div class="modal-actions">
                    <button type="button" id="modal-close-btn" class="btn-secondary">Close</button>
                    <button type="submit" class="btn-primary">Confirm Booking</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const turfSelect = document.getElementById('turf-select');
            const detailsButton = document.getElementById('view-details-btn');
            const calendarEl = document.getElementById('booking-calendar');
            const isLoggedIn = ${not empty sessionScope.user};
            if (!turfSelect.value) {
                detailsButton.hidden = true;
                calendarEl.textContent = 'No active turfs are available yet.';
                return;
            }
            const sportSelect = document.getElementById('modal-sport-id');
            const turfSports = {
                <c:forEach items="${turfs}" var="turf" varStatus="status">
                "${turf.id}": [<c:forEach items="${turf.sportIds}" var="sportId" varStatus="sportStatus">${sportId}<c:if test="${!sportStatus.last}">,</c:if></c:forEach>]<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            };

            updateDetailsButton();
            updateSports();
            if (!window.FullCalendar) {
                calendarEl.textContent = 'The schedule could not load. Check your connection and refresh this page.';
                return;
            }
            const calendarError = document.getElementById('calendar-error');

            // --- Calendar Initialization ---
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                headerToolbar: { left: 'prev,next today', center: 'title', right: 'timeGridWeek,timeGridDay' },
                slotMinTime: '06:00:00',
                slotMaxTime: '24:00:00',
                allDaySlot: false,
                events: function(fetchInfo, successCallback, failureCallback) {
                    const turfId = turfSelect.value;
                    fetch(`${pageContext.request.contextPath}/api/bookings?turfId=\${turfId}&start=\${fetchInfo.startStr}&end=\${fetchInfo.endStr}`)
                        .then(response => response.json())
                        .then(data => { calendarError.hidden = true; successCallback(data); })
                        .catch(error => { calendarError.textContent = 'Availability could not be loaded. Please refresh to try again.'; calendarError.hidden = false; failureCallback(error); });
                },
                eventColor: '#dc2626',
                dateClick: handleDateClick
            });
            calendar.render();

            // --- Event Handlers ---
            turfSelect.addEventListener('change', function() {
                updateDetailsButton();
                updateSports();
                calendar.refetchEvents(); // Reload events for the new turf
            });

            function updateSports() {
                const available = turfSports[turfSelect.value] || [];
                Array.from(sportSelect.options).forEach(option => {
                    option.hidden = !available.includes(Number(option.value));
                });
                const firstAvailable = Array.from(sportSelect.options).find(option => !option.hidden);
                sportSelect.value = firstAvailable ? firstAvailable.value : '';
            }

            function updateDetailsButton() {
                const turfId = turfSelect.value;
                if (turfId) {
                    detailsButton.href = `${pageContext.request.contextPath}/turf-details?turfId=\${turfId}`;
                    detailsButton.classList.remove('disabled');
                }
            }

            // --- Modal Logic ---
            const modal = document.getElementById('booking-modal');
            const modalForm = document.getElementById('modal-booking-form');
            const modalError = document.getElementById('modal-error');
            const closeModalBtn = document.getElementById('modal-close-btn');

            function handleDateClick(info) {
                if (info.date < new Date()) {
                    alert("You cannot book a time slot in the past.");
                    return;
                }
                if (!isLoggedIn) {
                    window.location.href = `${pageContext.request.contextPath}/login?next=%2Fbooking`;
                    return;
                }
                const start = info.date;
                const end = new Date(start.getTime() + 60 * 60 * 1000); // Default 1 hour booking

                document.getElementById('modal-turf-id').value = turfSelect.value;
                document.getElementById('modal-start-time').value = toLocalISOString(start);
                document.getElementById('modal-end-time').value = toLocalISOString(end);

                document.getElementById('modal-title').innerText = `Book Slot at \${turfSelect.options[turfSelect.selectedIndex].text}`;
                modalError.style.display = 'none';
                modal.style.display = 'flex';
            }

            closeModalBtn.addEventListener('click', () => modal.style.display = 'none');
            modal.addEventListener('click', (e) => {
                if (e.target === modal) modal.style.display = 'none';
            });

            modalForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const submitButton = modalForm.querySelector('button[type="submit"]');
                submitButton.disabled = true;
                submitButton.textContent = 'Confirming…';
                fetch('${pageContext.request.contextPath}/booking', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(modalForm))
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        modal.style.display = 'none';
                        calendar.refetchEvents();
                    } else {
                        modalError.textContent = data.message;
                        modalError.style.display = 'block';
                    }
                })
                .catch(() => {
                    modalError.textContent = 'We couldn’t complete the booking. Check your connection and try again.';
                    modalError.style.display = 'block';
                })
                .finally(() => {
                    submitButton.disabled = false;
                    submitButton.textContent = 'Confirm booking';
                });
            });

            document.addEventListener('keydown', event => {
                if (event.key === 'Escape' && modal.style.display === 'flex') modal.style.display = 'none';
            });

            // --- Initial Setup ---
        });

        function toLocalISOString(date) {
            const tzoffset = (new Date()).getTimezoneOffset() * 60000;
            return (new Date(date - tzoffset)).toISOString().slice(0, 16);
        }
    </script>
</body>
</html>
