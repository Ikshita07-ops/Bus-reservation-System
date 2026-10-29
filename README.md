# VoyageBus Express - Bus Reservation Management System

A complete, enterprise-grade **Bus Reservation Management System** built with **Java 11, traditional Spring MVC, Hibernate ORM, MySQL 8, JSP, HTML, CSS, JavaScript, Maven, and Apache Tomcat 9**.

The application features a modern, human-crafted design in a clean **white and red** palette (`#FFFFFF` background, `#D62828` primary red, `#A61B1B` dark red, `#222222` text, `#F7F7F7` secondary background, and `#E5E5E5` borders).

---

## 1. System Features

### User Features
- **User Authentication & Session Management**: Secure user registration, BCrypt password hashing, session-based authentication, and stateful login/logout.
- **Intercity Bus Search**: Search buses by departure city, destination city, and journey date with filters for bus categories (Volvo Multi-Axle, AC Sleeper, Luxury Seater) and departure times.
- **Rich Schedule Information**: Live display of operator name, coach model, departure/arrival times, travel duration, fare in INR, and live seat availability calculated from the database.
- **Interactive Seat Selection**: Graphical coach layouts for both sleeper (lower & upper berths) and 2+2 seater configurations. Features driver cabin orientation, available seats, booked seats, selected seats, real-time fare calculation, and gender allocation.
- **Instant Booking & Unique Reference**: Generates unique references (e.g., `BRS-20261021-9X2A`), creates database records for bookings and individual seats in an atomic transaction.
- **Printable E-Ticket / Boarding Pass**: Dedicated electronic boarding pass with barcode simulation, passenger allocation, route details, and a print stylesheet.
- **My Bookings & One-Click Cancellation**: Real-time travel history for logged-in users, displaying status badges (`CONFIRMED`, `CANCELLED`). Allows cancellation of eligible upcoming trips with immediate seat release.

### Admin Features
- **Role-Based Access Control**: Secure `/admin/**` endpoints protected by a server-side `SecurityInterceptor` requiring `ROLE_ADMIN`.
- **Executive Dashboard**: Real-time metrics including Total Revenue (INR), Active Bookings, Total Fleet, Total Routes, Active Schedules, and Registered Users, plus a table of recent reservations.
- **Fleet Management (Buses)**: Full CRUD operations for coaches (Registration Number, Operator Name, Bus Model, Capacity, Onboard Amenities, and Active Status).
- **Route Management**: Full CRUD operations for intercity routes (Source City, Destination City, Distance in km, and Estimated Duration).
- **Schedule & Fare Management**: Assign active buses to routes, set departure and arrival times, configure dynamic fares, and update journey status (`SCHEDULED`, `COMPLETED`, `CANCELLED`).
- **Reservation Oversight**: View all passenger bookings, inspect customer accounts, and execute administrative cancellations with immediate seat restoration.
- **User Directory**: View registered customer and administrator accounts.

---

## 2. Technology Stack & Compatible Versions

| Component | Technology | Version |
|---|---|---|
| Language | Java (JDK) | 11.0.32 LTS |
| Web Framework | Spring MVC (`spring-webmvc`, `spring-orm`, `spring-tx`) | 5.3.34 |
| ORM Framework | Hibernate Core | 5.6.15.Final |
| Database | MySQL Server & Connector/J | 8.0.33 / 8.0.45 |
| Connection Pool | HikariCP | 4.0.3 |
| Security / Hashing | Spring Security Crypto (BCrypt) | 5.8.11 |
| View Layer | JSP 2.3, JSTL 1.2, HTML5, Vanilla CSS3, JavaScript | Standard |
| Servlet Container | Apache Tomcat | 9.0.96 |
| Build Tool | Apache Maven | 3.9.6 |
| Testing | JUnit 5 & Mockito | 5.10.0 / 5.5.0 |

---

## 3. Database Architecture & Concurrency Safety

### Tables Overview
1. **`users`**: Stores user profiles, hashed passwords, contact info, and assigned roles (`ROLE_CUSTOMER`, `ROLE_ADMIN`).
2. **`buses`**: Fleet inventory detailing registration numbers, bus models, seat capacities, and onboard amenities.
3. **`routes`**: Origin and destination city pairs with unique constraints on `(source_city, destination_city)`.
4. **`schedules`**: Time-specific departures connecting buses and routes with dates, timings, fares, and statuses.
5. **`bookings`**: Persistent customer reservations with unique booking references, passenger details, seat counts, and status.
6. **`booking_seats`**: Individual seat allocations mapped to schedules and bookings with statuses (`BOOKED`, `CANCELLED`).

### Concurrency & Transactional Seat Safety
- **Pessimistic Write Locking**: During booking creation, `ScheduleDao.findByIdForUpdate()` locks the schedule record (`SELECT ... FOR UPDATE`), serializing concurrent booking attempts for the same coach departure.
- **Atomic Availability Check**: Live seat queries verify that none of the requested seats exist with `status = 'BOOKED'`. If a race condition occurs, `SeatAlreadyBookedException` is thrown and the transaction rolls back.
- **Immediate Seat Release**: When a booking is cancelled, its `booking_seats` status updates to `CANCELLED`, instantly restoring seat availability in search and coach selection.

---

## 4. Default Credentials

| Role | Email | Password | Access Level |
|---|---|---|---|
| **Administrator** | `admin@busreservation.com` | `admin123` | Full access to Admin Console & Dashboard |
| **Customer 1** | `john.doe@example.com` | `password123` | Booking, viewing tickets, cancellation |
| **Customer 2** | `ikshita@example.com` | `password123` | Booking, viewing tickets, cancellation |

*Note: The login page includes quick-fill buttons for immediate testing.*

---

## 5. Setup & Execution Instructions

### Step 1: Database Setup
Make sure MySQL Server 8.0 is running on `localhost:3306`.
Execute the schema and seed scripts:

```powershell
# Using MySQL Command Line Client
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p bus_reservation_db < "d:\Ikshita\Bus Reservation\src\main\resources\sql\schema.sql"
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p bus_reservation_db < "d:\Ikshita\Bus Reservation\src\main\resources\sql\data.sql"
```

### Step 2: Database Credentials Configuration
Database credentials can be adjusted in [src/main/resources/application.properties](file:///d:/Ikshita/Bus%20Reservation/src/main/resources/application.properties):

```properties
db.url=jdbc:mysql://localhost:3306/bus_reservation_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true
db.username=root
db.password=root
```
*Alternatively, set environment variables `DB_URL`, `DB_USER`, and `DB_PASSWORD`.*

### Step 3: Build the Application with Maven
Build the project and run the automated test suite:

```powershell
# In project root: d:\Ikshita\Bus Reservation
& "D:\Ikshita\tools\apache-maven-3.9.6\bin\mvn.cmd" clean package
```
*This compiles all source files, runs 9 unit/service tests, and generates `target/busreservation.war`.*

### Step 4: Deploy and Run on Apache Tomcat 9
Copy the compiled WAR file to Tomcat's `webapps` folder:

```powershell
Copy-Item "target\busreservation.war" "D:\Ikshita\tools\apache-tomcat-9.0.96\webapps\ROOT.war" -Force
Copy-Item "target\busreservation.war" "D:\Ikshita\tools\apache-tomcat-9.0.96\webapps\busreservation.war" -Force

# Start Tomcat Server
& "D:\Ikshita\tools\apache-tomcat-9.0.96\bin\catalina.bat" run
```

### Step 5: Open in Browser
Open your browser and navigate to:
- **Home Page**: [http://localhost:8080/](http://localhost:8080/) or [http://localhost:8080/busreservation/](http://localhost:8080/busreservation/)
- **Bus Search**: [http://localhost:8080/search](http://localhost:8080/search)
- **Sign In**: [http://localhost:8080/auth/login](http://localhost:8080/auth/login)
- **Admin Dashboard**: [http://localhost:8080/admin/dashboard](http://localhost:8080/admin/dashboard)

---

## 6. Verification and Test Results

The application has been verified end-to-end:
- **Unit & Service Tests**: 9/9 tests passed via Maven Surefire:
  - `UserServiceTest`: Registration validation, duplicate email detection, BCrypt credential verification.
  - `BookingServiceTest`: Concurrency-safe booking, duplicate seat exception handling, owner cancellation authorization.
  - `PasswordUtilTest`: BCrypt hash and match verification.
- **Search & Filter Operations**: Verified queries across routes, dates, and bus types.
- **Seat Map & Allocation**: Interactive coach layout verified for lower and upper sleeper berths as well as seater buses.
- **Live Seat Availability**: Verified that booked seats are immediately flagged as unavailable via the REST API (`/api/schedules/{id}/seats`).
- **Duplicate Booking Prevention**: Verified that attempting to book an already occupied seat returns an error and prevents database write.
- **Cancellation & Seat Release**: Verified that cancelling a booking marks the reservation and seats as `CANCELLED`, restoring the seats to the live pool.
- **Role-Based Security**: Verified that unauthenticated users are redirected to login, and non-admin customers are blocked from administrative routes.
- **Admin Management Operations**: Verified adding, editing, and deleting buses, routes, schedules, and reservations.
