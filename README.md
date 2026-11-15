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
| **Browse Turfs** | View turf details with location, supported sports, ratings, and hourly rates |
| **Dynamic Booking** | Sports dropdown dynamically updates based on the selected turf |
| **My Bookings** | View complete booking history with upcoming and past reservations |
| **Cancel Bookings** | Cancel upcoming bookings up to 12 hours before the start time |
| **Turf Reviews** | Leave reviews and ratings for turfs after your booking |

### 🛡️ Admin Panel
| Feature | Description |
|---------|-------------|
| **Secure Admin Login** | Separate role-based login at `/admin/login` |
| **Booking Dashboard** | View, filter, cancel, or re-confirm any booking from all users |
| **Turf Management** | Add and edit turfs, rates, status, and sport assignments |
| **Sport Management** | Full CRUD — add, edit, and delete sports available on the platform |
| **Review Moderation** | View and manage user reviews across all turfs |
| **Analytics Dashboard** | Visual analytics for booking trends and usage, with estimated confirmed booking value at current turf rates |
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

On Windows, install Temurin 17 from PowerShell with `winget install --exact --id EclipseAdoptium.Temurin.17.JDK`. Install Maven with Chocolatey (`choco install maven`) or download the Maven binary archive and add its `bin` directory to `PATH`. Install Tomcat and MySQL using their Windows installers linked above.

### Installation

#### 1️⃣ Open the repository

```powershell
cd "D:\College Projects\APEX_TURF\APEX_TURF"
```

#### 2️⃣ Create the database and sample turfs

From PowerShell, initialize MySQL and load the bundled demo data (replace `root` if you use a different MySQL account):

```powershell
Get-Content -Raw src/main/resources/db/schema.sql | mysql -u root -p
Get-Content -Raw src/main/resources/db/migrations/V1__turf_hourly_rate.sql | mysql -u root -p apex_turf
Get-Content -Raw src/main/resources/db/seed.sql | mysql -u root -p apex_turf
```

The seed contains two sample turfs and three sports. It does not create accounts or passwords.
After upgrading an older database, review existing rates in the admin turf editor; migrated facilities default to zero until you set their actual hourly rates.

#### 3️⃣ Configure local settings

Copy `.env.example` to `.env` if it does not already exist, then enter your MySQL username and password. `.env` is read from the current working directory and is ignored by Git.

```powershell
if (!(Test-Path .env)) { Copy-Item .env.example .env }
notepad .env
```

Email is optional. To enable Gmail notifications, set `APEX_MAIL_SENDER`, `APEX_MAIL_PASSWORD` (a Gmail App Password), and `APEX_ADMIN_EMAIL` in `.env`. Without them, bookings work and email is skipped.

#### 4️⃣ Build and deploy

Install Java 17+, Maven 3.9+, and Tomcat 10.1+. Then, from the repository root:

```powershell
mvn clean package
Copy-Item target/apex-turf.war "$env:CATALINA_HOME\webapps\apex-turf.war" -Force
```

Load `.env` into the current PowerShell session and run Tomcat in that same session:

```powershell
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$' -and -not $Matches[1].StartsWith('#')) {
        [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim('"', "'"), 'Process')
    }
}
& "$env:CATALINA_HOME\bin\catalina.bat" run
```

Set `CATALINA_HOME` to your Tomcat 10.1 installation directory before deploying, for example `$env:CATALINA_HOME = 'C:\tools\apache-tomcat-10.1'`. The app reads database and email settings from process environment variables first, then `.env` in its working directory. For Tomcat service installs, configure the same `APEX_*` variables in the service environment.

#### 5️⃣ Access the application

| Page | URL |
|------|-----|
| 🏠 Home | `http://localhost:8080/apex-turf/` |
| 🔐 User Login | `http://localhost:8080/apex-turf/login` |
| 📝 User Signup | `http://localhost:8080/apex-turf/signup` |
| 🛡️ Admin Login | `http://localhost:8080/apex-turf/admin/login` |

Create a normal account at `/signup`, then promote that account to admin in MySQL (replace the email):

```sql
UPDATE users SET role = 'ADMIN' WHERE email = 'you@example.com';
```

---

## 🗄️ Database Schema

The complete, version-controlled schema is in [`src/main/resources/db/schema.sql`](src/main/resources/db/schema.sql); sample sports and turfs are in [`src/main/resources/db/seed.sql`](src/main/resources/db/seed.sql). An idempotent migration adds hourly rates to an older schema. Load these using the PowerShell commands above. The schema keeps one review per booking and indexes the booking lookup columns. Analytics estimates confirmed booking value using the turf’s current hourly rate; it does not represent collected payments.

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
│             │ hourly_rate  │            │
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
│       │   │   ├── DatabaseConfig.java      # HikariCP datasource singleton
│       │   │   └── EnvironmentConfig.java   # Process/.env configuration
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
│       │   ├── application.properties       # Database defaults
│       │   ├── email.properties.example     # Email config template
│       │   └── db/                          # Schema, seed, and migration scripts
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
