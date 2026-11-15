<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/sidebar.jsp"/>

<main class="admin-main">
    <div class="admin-header">
        <h1>Analytics Dashboard</h1>
    </div>
    <c:if test="${not empty error}"><div class="alert error"><c:out value="${error}"/></div></c:if>

    <div class="kpi-grid">
        <div class="admin-card kpi-card">
            <h4>Total Bookings</h4>
            <span class="kpi-value" id="total-bookings-val">0</span>
        </div>
        <div class="admin-card kpi-card">
            <h4>Estimated confirmed value · current rates</h4>
            <span class="kpi-value">&#8377;<span id="total-revenue-val">0</span></span>
        </div>
    </div>

    <div class="chart-grid">
        <div class="admin-card chart-container">
            <h3>Bookings per Day (Last 30 Days)</h3>
            <canvas id="bookingsPerDayChart"></canvas>
        </div>
        <div class="admin-card chart-container">
            <h3>Peak Booking Hours</h3>
            <canvas id="peakTimeChart"></canvas>
        </div>
        <div class="admin-card chart-container">
            <h3>Most Popular Turfs</h3>
            <canvas id="popularTurfsChart"></canvas>
        </div>
        <div class="admin-card chart-container">
            <h3>Most Popular Sports</h3>
            <canvas id="popularSportsChart"></canvas>
        </div>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // Safely parse the JSON data from the servlet
    const dashboardData = ${dashboardDataJson};
    dashboardData.popularTurfs = dashboardData.popularTurfs || {};
    dashboardData.popularSports = dashboardData.popularSports || {};
    dashboardData.peakTimeUsage = dashboardData.peakTimeUsage || {};
    dashboardData.bookingsPerDay = dashboardData.bookingsPerDay || {};

    document.addEventListener('DOMContentLoaded', function() {
        // Populate KPI Cards
        document.getElementById('total-bookings-val').textContent = dashboardData.totalBookings;
        document.getElementById('total-revenue-val').textContent = dashboardData.totalRevenue.toLocaleString('en-IN');

        if (!window.Chart) {
            document.querySelector('.chart-grid').innerHTML = '<div class="chart-container">Charts could not load. Refresh this page to try again.</div>';
            return;
        }
        Chart.defaults.color = '#a0a99a';
        Chart.defaults.font.family = "'DM Sans', sans-serif";
        // Render Charts
        renderLineChart('bookingsPerDayChart', 'Daily Bookings', dashboardData.bookingsPerDay);
        renderBarChart('peakTimeChart', 'Bookings per Hour', dashboardData.peakTimeUsage);
        renderDoughnutChart('popularTurfsChart', dashboardData.popularTurfs);
        renderDoughnutChart('popularSportsChart', dashboardData.popularSports);
    });

    function renderLineChart(canvasId, label, data) {
        const ctx = document.getElementById(canvasId).getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: label,
                    data: Object.values(data),
                    borderColor: '#c6f36b',
                    backgroundColor: 'rgba(198, 243, 107, 0.12)',
                    fill: true,
                    tension: 0.1
                }]
            }
        });
    }

    function renderBarChart(canvasId, label, data) {
        const ctx = document.getElementById(canvasId).getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: label,
                    data: Object.values(data),
                    backgroundColor: 'rgba(198, 243, 107, 0.72)',
                    borderColor: '#c6f36b',
                    borderWidth: 1
                }]
            }
        });
    }

    function renderDoughnutChart(canvasId, data) {
        const ctx = document.getElementById(canvasId).getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Bookings',
                    data: Object.values(data),
                    backgroundColor: [
                        'rgba(198, 243, 107, 0.88)',
                        'rgba(121, 166, 87, 0.88)',
                        'rgba(75, 130, 103, 0.88)',
                        'rgba(204, 177, 105, 0.88)',
                        'rgba(122, 137, 107, 0.88)'
                    ],
                    hoverOffset: 4
                }]
            }
        });
    }
</script>

<jsp:include page="common/footer.jsp"/>
