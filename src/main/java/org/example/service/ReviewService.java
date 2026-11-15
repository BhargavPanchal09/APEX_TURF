package org.example.service;

import org.example.dao.ReviewDao;
import org.example.dao.BookingDao;
import org.example.model.Review;
import java.sql.SQLException;
import java.util.List;

public class ReviewService {
    private final ReviewDao reviewDao = new ReviewDao();
    private final BookingDao bookingDao = new BookingDao();

    public List<Review> getReviewsForTurf(long turfId) throws SQLException {
        return reviewDao.findByTurfId(turfId);
    }

    public double getAverageRating(long turfId) throws SQLException {
        // Round to one decimal place
        double avg = reviewDao.getAverageRatingForTurf(turfId);
        return Math.round(avg * 10.0) / 10.0;
    }

    public void submitReview(Review review) throws SQLException, IllegalStateException {
        if (review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalStateException("Rating must be between 1 and 5.");
        }
        var booking = bookingDao.findById(review.getBookingId());
        if (booking == null || !booking.getUserId().equals(review.getUserId()) ||
                !booking.getTurfId().equals(review.getTurfId()) ||
                !"CONFIRMED".equals(booking.getStatus()) || booking.getEndTime().isAfter(java.time.LocalDateTime.now())) {
            throw new IllegalStateException("A review can only be submitted by the customer after a completed booking.");
        }
        if (reviewDao.hasUserReviewedBooking(review.getBookingId())) {
            throw new IllegalStateException("You have already submitted a review for this booking.");
        }
        reviewDao.create(review);
    }

    public void deleteReview(long reviewId) throws SQLException {
        reviewDao.delete(reviewId);
    }

    public List<Review> getAllReviews() throws SQLException {
        return reviewDao.findAll();
    }
}
