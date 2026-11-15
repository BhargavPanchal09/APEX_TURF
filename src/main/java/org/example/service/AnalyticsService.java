package org.example.service;

import org.example.dao.AnalyticsDao;
import org.example.model.AnalyticsDashboardDTO;
import java.sql.SQLException;

public class AnalyticsService {
    private final AnalyticsDao analyticsDao = new AnalyticsDao();

    public AnalyticsDashboardDTO getDashboardData() throws SQLException {
        AnalyticsDashboardDTO dto = new AnalyticsDashboardDTO();

        dto.setTotalBookings(analyticsDao.getTotalBookings());
        dto.setPopularTurfs(analyticsDao.getPopularTurfs());
        dto.setPopularSports(analyticsDao.getPopularSports());
        dto.setPeakTimeUsage(analyticsDao.getPeakTimeUsage());
        dto.setBookingsPerDay(analyticsDao.getBookingsPerDay());

        dto.setTotalRevenue(analyticsDao.getEstimatedRevenue());

        return dto;
    }
}
