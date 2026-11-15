<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/sidebar.jsp"/>

<main class="admin-main">
    <div class="admin-header">
        <h1>Manage Turfs</h1>
        <a href="${pageContext.request.contextPath}/admin/turfs?action=new" class="btn-primary">Add New Turf</a>
    </div>

    <div class="admin-card">
        <c:if test="${empty turfList}"><div class="empty-state"><h2>No turfs yet</h2><p>Add a turf, set its location and hourly rate, then assign the sports it supports.</p><a href="${pageContext.request.contextPath}/admin/turfs?action=new" class="btn-primary">Add your first turf</a></div></c:if>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Location</th>
                    <th>Rate / hour</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${turfList}" var="turf">
                    <tr>
                        <td>${turf.id}</td>
                        <td>${turf.name}</td>
                        <td>${turf.location}</td>
                        <td>&#8377;<fmt:formatNumber value="${turf.hourlyRate}" minFractionDigits="0" maxFractionDigits="2"/></td>
                        <td>
                            <span class="status-${turf.active ? 'active' : 'inactive'}">
                                ${turf.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/turf-details?turfId=${turf.id}" class="btn-view" target="_blank">View</a>
                            <a href="${pageContext.request.contextPath}/admin/turfs?action=edit&id=${turf.id}" class="btn-edit">Edit</a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/turfs" onsubmit="return confirm('Deactivate this turf? It will leave future listings, and past bookings will be preserved.')"><input type="hidden" name="action" value="deactivate"><input type="hidden" name="id" value="${turf.id}"><button class="btn-delete" type="submit">Deactivate</button></form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="common/footer.jsp"/>
