<div align="center">

# ⚽ APEX TURF

### Smart Turf Booking Web Application

[![Java](https://img.shields.io/badge/Java-17%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-1572B6?style=for-the-badge&logo=eclipseadoptium&logoColor=white)](https://jakarta.ee/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Maven](https://img.shields.io/badge/Maven-3.9-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)](https://maven.apache.org/)
[![Tomcat](https://img.shields.io/badge/Tomcat-10.1-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)](https://tomcat.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

A full-featured, production-ready sports turf booking system built with Java Servlets & JSP following the MVC architecture. Inspired by [hudle.in](https://hudle.in).

[Features](#-features) · [Tech Stack](#-tech-stack) · [Getting Started](#-getting-started) · [Database Schema](#-database-schema) · [Project Structure](#-project-structure) · [Contributing](#-contributing)

</div>

---

## 📖 About The Project

**APEX TURF** is a smart turf booking platform designed for sports enthusiasts and facility administrators. Users can browse available turfs, book time slots for their favorite sports, manage their reservations, and leave reviews. Administrators get a powerful dashboard to manage turfs, sports, bookings, user reviews, and view analytics — all from a single web interface.

The application features **role-based access control**, **automated email notifications**, **secure password hashing**, and a **dynamic booking system** where available sports update in real time based on the selected turf.

---

## ✨ Features

### 🏟️ User Features
| Feature | Description |
|---------|-------------|
| **User Authentication** | Secure registration and login with BCrypt-hashed passwords |
| **Browse Turfs** | View detailed turf pages with available sports, location info |
| **Dynamic Booking** | Sports dropdown dynamically updates based on the selected turf |
| **My Bookings** | View complete booking history with upcoming and past reservations |
| **Cancel Bookings** | Cancel upcoming bookings up to 12 hours before the start time |
| **Turf Reviews** | Leave reviews and ratings for turfs after your booking |

### 🛡️ Admin Panel
| Feature | Description |
|---------|-------------|
| **Secure Admin Login** | Separate role-based login at `/admin/login` |
| **Booking Dashboard** | View, filter, cancel, or re-confirm any booking from all users |
| **Turf Management** | Full CRUD — add, edit, and deactivate turfs with sport assignments |
| **Sport Management** | Full CRUD — add, edit, and delete sports available on the platform |
| **Review Moderation** | View and manage user reviews across all turfs |
| **Analytics Dashboard** | Visual analytics with booking trends, revenue, and usage stats |
| **CSV Export** | Export filtered booking data to CSV for reporting |

### ⚙️ System Features
| Feature | Description |
|---------|-------------|
| **Email Notifications** | Automated emails for booking confirmations, cancellations, and admin alerts |
| **Connection Pooling** | HikariCP for efficient, high-performance database connections |
| **Role-Based Security** | All `/admin/*` routes are protected via servlet filters |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Java 17+ |
| **Framework** | Jakarta EE 10 (Servlet 6.0, JSP 3.1, JSTL 3.0) |
| **Architecture** | MVC (Model-View-Controller) |
| **Database** | MySQL 8.0 |
| **Connection Pool** | HikariCP 5.1 |
| **Build Tool** | Apache Maven (WAR packaging) |
| **Server** | Apache Tomcat 10.1+ |
| **Security** | jBCrypt for password hashing |
| **Email** | Jakarta Mail (Angus Mail) via Gmail SMTP |
| **JSON** | Gson 2.10 |
| **Logging** | SLF4J Simple |

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed on your system:

- **Java JDK 17** or newer → [Download](https://adoptium.net/)
- **Apache Maven 3.9+** → [Download](https://maven.apache.org/download.cgi)
- **Apache Tomcat 10.1+** → [Download](https://tomcat.apache.org/download-10.cgi)
- **MySQL Server 8.0+** → [Download](https://dev.mysql.com/downloads/mysql/)

### Installation

#### 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/APEX_TURF.git
cd APEX_TURF
```

#### 2️⃣ Set Up the Database

Open your MySQL client and run:

```sql
CREATE DATABASE apex_turf;
USE apex_turf;
```

Then execute the schema from the [Database Schema](#-database-schema) section below to create all required tables.

#### 3️⃣ Configure Database Credentials

Edit `src/main/resources/application.properties` with your local MySQL credentials:

```properties
db.url=jdbc:mysql://localhost:3306/apex_turf?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.username=root
db.password=YOUR_MYSQL_PASSWORD
```

#### 4️⃣ Configure Email Notifications *(Optional)*

Copy the example config and fill in your Gmail credentials:

```bash
cp src/main/resources/email.properties.example src/main/resources/email.properties
```

Edit `email.properties`:

```properties
sender.email=your-email@gmail.com
sender.password=YOUR_16_CHARACTER_APP_PASSWORD
admin.email=admin-notification-email@example.com
```

> **Note:** You need a [Gmail App Password](https://support.google.com/accounts/answer/185833) (not your regular password). Enable 2-Step Verification in your Google Account first.

#### 5️⃣ Build the Project

```bash
mvn clean package
```

This generates `target/apex-turf.war`.

#### 6️⃣ Deploy to Tomcat

Copy the WAR file to your Tomcat installation:

```bash
cp target/apex-turf.war /path/to/tomcat/webapps/
```

Start Tomcat:

```bash
# Linux / macOS
cd /path/to/tomcat/bin && ./startup.sh

# Windows
cd \path\to\tomcat\bin && startup.bat
```

#### 7️⃣ Access the Application

| Page | URL |
|------|-----|
| 🏠 Home | `http://localhost:8080/apex-turf/` |
| 🔐 User Login | `http://localhost:8080/apex-turf/login` |
| 📝 User Signup | `http://localhost:8080/apex-turf/signup` |
| 🛡️ Admin Login | `http://localhost:8080/apex-turf/admin/login` |

---

## 🗄️ Database Schema

Run the following SQL in your `apex_turf` database to create all required tables:

```sql
-- Users table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(32) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) NOT NULL DEFAULT 'USER'
);

-- Turfs table
CREATE TABLE turfs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(200) NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1
);

-- Sports table
CREATE TABLE sports (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1
);

-- Many-to-Many: Turf ↔ Sport
CREATE TABLE turf_sports (
    turf_id BIGINT NOT NULL,
    sport_id BIGINT NOT NULL,
    PRIMARY KEY (turf_id, sport_id),
    FOREIGN KEY (turf_id) REFERENCES turfs(id) ON DELETE CASCADE,
    FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE
);

-- Bookings table
CREATE TABLE bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    turf_id BIGINT NOT NULL,
    sport_id BIGINT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status VARCHAR(32) NOT NULL,
    created_at DATETIME NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_turf FOREIGN KEY (turf_id) REFERENCES turfs(id),
    CONSTRAINT fk_sport FOREIGN KEY (sport_id) REFERENCES sports(id),
    INDEX idx_turf_time (turf_id, start_time, end_time)
);

-- Reviews table
CREATE TABLE reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    turf_id BIGINT NOT NULL,
    booking_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (turf_id) REFERENCES turfs(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

### ER Diagram

```
┌──────────┐       ┌──────────────┐       ┌──────────┐
│  users   │       │  turf_sports │       │  sports  │
│──────────│       │──────────────│       │──────────│
│ id (PK)  │       │ turf_id (FK) │       │ id (PK)  │
│ name     │       │ sport_id(FK) │       │ name     │
│ email    │       └──────┬───────┘       │ active   │
│ phone    │              │               └────┬─────┘
│ password │       ┌──────┴───────┐            │
│ role     │       │    turfs     │            │
└────┬─────┘       │──────────────│            │
     │             │ id (PK)      │            │
     │             │ name         │            │
     │             │ location     │            │
     │             │ active       │            │
     │             └──────┬───────┘            │
     │                    │                    │
     │             ┌──────┴───────┐            │
     └────────────►│   bookings   │◄───────────┘
                   │──────────────│
                   │ id (PK)      │
                   │ user_id (FK) │
                   │ turf_id (FK) │
                   │ sport_id(FK) │
                   │ start_time   │
                   │ end_time     │
                   │ status       │
                   │ created_at   │
                   └──────┬───────┘
                          │
                   ┌──────┴───────┐
                   │   reviews    │
                   │──────────────│
                   │ id (PK)      │
                   │ user_id (FK) │
                   │ turf_id (FK) │
                   │ booking_id   │
                   │ rating       │
                   │ comment      │
                   │ created_at   │
                   └──────────────┘
```

---

## 📁 Project Structure

```
APEX_TURF/
├── pom.xml                                  # Maven build configuration
├── src/
│   └── main/
│       ├── java/org/example/
│       │   ├── config/
│       │   │   └── DatabaseConfig.java      # HikariCP datasource singleton
│       │   ├── model/
│       │   │   ├── User.java                # User entity
│       │   │   ├── Turf.java                # Turf entity
│       │   │   ├── Sport.java               # Sport entity
│       │   │   ├── Booking.java             # Booking entity
│       │   │   ├── Review.java              # Review entity
│       │   │   └── AnalyticsDashboardDTO.java
│       │   ├── dao/                         # Data Access Layer
│       │   │   ├── UserDao.java
│       │   │   ├── TurfDao.java
│       │   │   ├── SportDao.java
│       │   │   ├── BookingDao.java
│       │   │   ├── ReviewDao.java
│       │   │   └── AnalyticsDao.java
│       │   ├── service/                     # Business Logic Layer
│       │   │   ├── UserService.java
│       │   │   ├── TurfService.java
│       │   │   ├── SportService.java
│       │   │   ├── BookingService.java
│       │   │   ├── ReviewService.java
│       │   │   ├── AnalyticsService.java
│       │   │   ├── EmailService.java
│       │   │   └── PasswordService.java
│       │   └── web/                         # Controllers (Servlets & Filters)
│       │       ├── LoginServlet.java
│       │       ├── SignupServlet.java
│       │       ├── LogoutServlet.java
│       │       ├── BookingServlet.java
│       │       ├── BookingApiServlet.java
│       │       ├── MyBookingsServlet.java
│       │       ├── TurfDetailsServlet.java
│       │       ├── ReviewServlet.java
│       │       ├── AuthenticationFilter.java
│       │       ├── AdminFilter.java
│       │       ├── AdminLoginServlet.java
│       │       ├── AdminDashboardServlet.java
│       │       ├── AdminTurfServlet.java
│       │       ├── AdminSportServlet.java
│       │       ├── AdminReviewServlet.java
│       │       ├── AdminAnalyticsServlet.java
│       │       └── AdminBookingExportServlet.java
│       ├── resources/
│       │   ├── application.properties       # Database config
│       │   └── email.properties.example     # Email config template
│       └── webapp/
│           ├── index.jsp                    # Landing page
│           ├── assets/css/
│           │   ├── styles.css               # Main stylesheet
│           │   └── admin-styles.css         # Admin panel styles
│           └── WEB-INF/
│               ├── web.xml
│               └── views/
│                   ├── common/header.jsp
│                   ├── login.jsp
│                   ├── signup.jsp
│                   ├── booking.jsp
│                   ├── my-bookings.jsp
│                   ├── turf-details.jsp
│                   ├── review-form.jsp
│                   └── admin/
│                       ├── common/
│                       ├── login.jsp
│                       ├── dashboard.jsp
│                       ├── turfs.jsp
│                       ├── turf-form.jsp
│                       ├── sports.jsp
│                       ├── sport-form.jsp
│                       ├── reviews.jsp
│                       └── analytics.jsp
└── .gitignore
```

---

## 🏗️ Architecture

The application follows a clean **MVC (Model-View-Controller)** architecture:

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│   Browser   │────►│  Servlet Filter  │────►│  Servlets   │
│  (Client)   │     │  (Auth / Admin)  │     │ (Controller)│
└─────────────┘     └──────────────────┘     └──────┬──────┘
                                                    │
                                             ┌──────▼──────┐
                                             │   Service   │
                                             │   Layer     │
                                             └──────┬──────┘
                                                    │
                    ┌──────────────┐          ┌─────▼──────┐
                    │  JSP Views   │◄─────────│  DAO Layer │
                    │  (View)      │          │  (Model)   │
                    └──────────────┘          └─────┬──────┘
                                                    │
                                             ┌──────▼──────┐
                                             │   MySQL     │
                                             │  Database   │
                                             └─────────────┘
```

- **Servlet Filters** handle authentication and role-based access control
- **Servlets** act as controllers, processing requests and routing to views
- **Services** encapsulate business logic (booking rules, email sending, password hashing)
- **DAOs** handle all database operations with HikariCP connection pooling
- **JSPs** render the HTML views with JSTL tags

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues, suggest features, or submit pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

<div align="center">

**Built with ❤️ using Java & Jakarta EE**

⭐ Star this repo if you found it useful!

</div>
