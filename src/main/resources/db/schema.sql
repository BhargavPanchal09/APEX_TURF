CREATE DATABASE IF NOT EXISTS apex_turf CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE apex_turf;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(32) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) NOT NULL DEFAULT 'USER'
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS turfs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(200) NOT NULL,
    hourly_rate DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sports (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS turf_sports (
    turf_id BIGINT NOT NULL,
    sport_id BIGINT NOT NULL,
    PRIMARY KEY (turf_id, sport_id),
    CONSTRAINT fk_turf_sports_turf FOREIGN KEY (turf_id) REFERENCES turfs(id) ON DELETE CASCADE,
    CONSTRAINT fk_turf_sports_sport FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    turf_id BIGINT NOT NULL,
    sport_id BIGINT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status VARCHAR(32) NOT NULL,
    created_at DATETIME NOT NULL,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_booking_turf FOREIGN KEY (turf_id) REFERENCES turfs(id),
    CONSTRAINT fk_booking_sport FOREIGN KEY (sport_id) REFERENCES sports(id),
    INDEX idx_turf_time (turf_id, start_time, end_time),
    INDEX idx_user_start (user_id, start_time)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    turf_id BIGINT NOT NULL,
    booking_id BIGINT NOT NULL UNIQUE,
    rating INT NOT NULL,
    comment TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_review_turf FOREIGN KEY (turf_id) REFERENCES turfs(id),
    CONSTRAINT fk_review_booking FOREIGN KEY (booking_id) REFERENCES bookings(id)
) ENGINE=InnoDB;
