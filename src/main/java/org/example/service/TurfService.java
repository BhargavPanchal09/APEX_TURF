package org.example.service;

import org.example.dao.TurfDao;
import org.example.model.Turf;
import java.sql.SQLException;
import java.util.List;

public class TurfService {
    private final TurfDao turfDao = new TurfDao();

    public List<Turf> getAllTurfs() throws SQLException {
        return turfDao.findAll();
    }

    public Turf getTurfById(long id) throws SQLException {
        return turfDao.findById(id);
    }

    public void saveTurf(Turf turf, List<Long> sportIds) throws SQLException {
        if (turf.getName() == null || turf.getName().isBlank() || turf.getName().length() > 150) {
            throw new IllegalArgumentException("Enter a turf name of 1 to 150 characters.");
        }
        if (turf.getLocation() == null || turf.getLocation().isBlank() || turf.getLocation().length() > 200) {
            throw new IllegalArgumentException("Enter a location of 1 to 200 characters.");
        }
        if (turf.getHourlyRate() == null || turf.getHourlyRate().signum() <= 0 || turf.getHourlyRate().scale() > 2) {
            throw new IllegalArgumentException("Enter a positive hourly rate with no more than two decimal places.");
        }
        if (turf.getId() == null) {
            // Create new turf
            turfDao.create(turf, sportIds);
        } else {
            // Update existing turf
            turfDao.update(turf, sportIds);
        }
    }

    public void deleteTurf(long id) throws SQLException {
        // We change the business logic here to deactivate instead of permanently deleting.
        turfDao.updateActiveStatus(id, false);
    }

    public List<Long> getSportIdsForTurf(long turfId) throws SQLException {
        return turfDao.findSportIdsForTurf(turfId);
    }
}
