<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Leave a Review - APEX TURF</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css"/>
    <style>
        .rating-field { margin: 0; padding: 0; border: 0; }
        .rating-field legend { margin-bottom: 8px; color: var(--muted); font-size: .88rem; font-weight: 600; }
        .star-rating { display: flex; flex-direction: row-reverse; justify-content: flex-end; width: max-content; }
        .star-rating input { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; }
        .star-rating label { display: inline-block; padding: 0 3px; color: #697362; font-size: 2.25rem; cursor: pointer; transition: color .16s; }
        .star-rating input:checked ~ label, .star-rating label:hover, .star-rating label:hover ~ label { color: var(--primary); }
        .star-rating input:focus-visible + label { outline: 2px solid var(--primary); outline-offset: 2px; border-radius: 4px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="container">
    <section class="card">
        <span class="eyebrow">The final whistle</span>
        <h1>How was the game?</h1>
        <p class="subtitle">Share your experience at <strong>${booking.turfName}</strong> from <strong>${booking.formattedStartTime}</strong>.</p>

        <form method="post" action="${pageContext.request.contextPath}/review" class="form-grid">
            <input type="hidden" name="bookingId" value="${booking.id}">
            <input type="hidden" name="turfId" value="${booking.turfId}">

            <fieldset class="rating-field" style="grid-column: 1 / -1;">
                <legend>Your rating</legend>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="5 stars" aria-label="5 stars">&#9733;</label>
                    <input type="radio" id="star4" name="rating" value="4"/><label for="star4" title="4 stars" aria-label="4 stars">&#9733;</label>
                    <input type="radio" id="star3" name="rating" value="3"/><label for="star3" title="3 stars" aria-label="3 stars">&#9733;</label>
                    <input type="radio" id="star2" name="rating" value="2"/><label for="star2" title="2 stars" aria-label="2 stars">&#9733;</label>
                    <input type="radio" id="star1" name="rating" value="1"/><label for="star1" title="1 star" aria-label="1 star">&#9733;</label>
                </div>
            </fieldset>

            <label style="grid-column: 1 / -1;">
                <span>Your review <small>(optional)</small></span>
                <textarea name="comment" rows="5" maxlength="2000" placeholder="Tell other players what you liked…"></textarea>
            </label>

            <button type="submit" class="btn-primary">Post review <span aria-hidden="true">→</span></button>
        </form>
    </section>
</main>
</body>
</html>
