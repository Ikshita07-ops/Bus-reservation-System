-- Bus Reservation Management System - Seed Data
-- Database: bus_reservation_db

USE `bus_reservation_db`;

-- 1. Insert Users
-- Default passwords:
-- admin@busreservation.com : admin123
-- john.doe@example.com      : password123
-- ikshita@example.com       : password123

INSERT INTO `users` (`id`, `full_name`, `email`, `phone`, `password`, `role`, `created_at`) VALUES
(1, 'System Administrator', 'admin@busreservation.com', '+91 9876543210', '$2a$10$DMyz3Isx7jkkbFhNkif/0O43O6grSAU9LIISQeDkRU4SRgxgX9PV.', 'ROLE_ADMIN', NOW()),
(2, 'John Doe', 'john.doe@example.com', '+91 9123456780', '$2a$10$jTFIgrvhyN985M8SczVmsuOzsUxh9g0dVc0a4u.3qUVxPV/Gog7QK', 'ROLE_CUSTOMER', NOW()),
(3, 'Ikshita Sharma', 'ikshita@example.com', '+91 9848012345', '$2a$10$jTFIgrvhyN985M8SczVmsuOzsUxh9g0dVc0a4u.3qUVxPV/Gog7QK', 'ROLE_CUSTOMER', NOW())
ON DUPLICATE KEY UPDATE `full_name` = VALUES(`full_name`);

-- 2. Insert Buses
INSERT INTO `buses` (`id`, `bus_number`, `bus_name`, `bus_type`, `total_seats`, `amenities`, `is_active`, `created_at`) VALUES
(1, 'TS09UB1001', 'Garuda Vega Multi-Axle', 'Volvo Multi-Axle AC (2+2)', 36, 'Free High-Speed WiFi, USB Charging Port, Reading Light, Mineral Water Bottle, Blanket', 1, NOW()),
(2, 'KA01AX2020', 'Orange Royal Sleeper', 'AC Sleeper (2+1)', 30, 'Air Conditioned, Individual Entertainment Screen, USB Charging, Blanket, Pillow, Water Bottle', 1, NOW()),
(3, 'MH12RQ3456', 'SRS Royal Luxury', 'Scania Multi-Axle AC (2+2)', 36, 'Reclining Ergonomic Seats, USB Port, Emergency Exit, GPS Real-time Tracking, First Aid Kit', 1, NOW()),
(4, 'TN07BZ7890', 'IntrCity SmartBus', 'BharatBenz AC Sleeper (2+1)', 30, 'Smart Boarding Lounge Access, Clean Restroom, Live Bus Tracking, Snacks & Water Bottle', 1, NOW()),
(5, 'DL01CA5544', 'VRL Travels Express', 'Volvo 9600 AC Sleeper', 30, 'Panoramic Windows, Premium Memory Foam Bedding, Sanitized Cabins, USB-C Fast Charging', 1, NOW()),
(6, 'AP28EE4321', 'Kaveri Travels Club Class', 'Non-AC Hi-Tech Seater (2+2)', 40, 'Comfortable High-Back Reclining Seats, Overhead Luggage Rack, Reading Lamp, First Aid', 1, NOW())
ON DUPLICATE KEY UPDATE `bus_name` = VALUES(`bus_name`);

-- 3. Insert Routes
INSERT INTO `routes` (`id`, `source_city`, `destination_city`, `distance_km`, `estimated_duration`, `created_at`) VALUES
(1, 'Hyderabad', 'Bangalore', 570, '8 hrs 30 mins', NOW()),
(2, 'Bangalore', 'Hyderabad', 570, '8 hrs 30 mins', NOW()),
(3, 'Bangalore', 'Chennai', 350, '6 hrs 00 mins', NOW()),
(4, 'Chennai', 'Bangalore', 350, '6 hrs 00 mins', NOW()),
(5, 'Mumbai', 'Pune', 150, '3 hrs 30 mins', NOW()),
(6, 'Pune', 'Mumbai', 150, '3 hrs 30 mins', NOW()),
(7, 'Delhi', 'Jaipur', 280, '5 hrs 00 mins', NOW()),
(8, 'Hyderabad', 'Vijayawada', 275, '5 hrs 15 mins', NOW()),
(9, 'Bangalore', 'Goa', 560, '11 hrs 00 mins', NOW()),
(10, 'Delhi', 'Hyderabad', 1580, '24 hrs 00 mins', NOW()),
(11, 'Hyderabad', 'Delhi', 1580, '24 hrs 00 mins', NOW())
ON DUPLICATE KEY UPDATE `distance_km` = VALUES(`distance_km`);

-- 4. Insert Schedules (Curdate and Upcoming Days)
-- Schedule 1: Hyderabad -> Bangalore Today Night
INSERT INTO `schedules` (`id`, `bus_id`, `route_id`, `journey_date`, `departure_time`, `arrival_time`, `fare`, `status`, `created_at`) VALUES
(1, 1, 1, CURDATE(), '21:00:00', '05:30:00', 1250.00, 'SCHEDULED', NOW()),
(2, 2, 1, CURDATE(), '22:15:00', '06:45:00', 1450.00, 'SCHEDULED', NOW()),
-- Hyderabad -> Bangalore Tomorrow
(3, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:00:00', '05:30:00', 1250.00, 'SCHEDULED', NOW()),
(4, 2, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '22:15:00', '06:45:00', 1450.00, 'SCHEDULED', NOW()),
(5, 4, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '23:00:00', '07:30:00', 1600.00, 'SCHEDULED', NOW()),
-- Hyderabad -> Bangalore Day After Tomorrow
(6, 1, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '21:00:00', '05:30:00', 1250.00, 'SCHEDULED', NOW()),
(7, 2, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '22:15:00', '06:45:00', 1450.00, 'SCHEDULED', NOW()),

-- Bangalore -> Chennai
(8, 3, 3, CURDATE(), '06:30:00', '12:30:00', 750.00, 'SCHEDULED', NOW()),
(9, 3, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '06:30:00', '12:30:00', 750.00, 'SCHEDULED', NOW()),
(10, 1, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '20:00:00', 850.00, 'SCHEDULED', NOW()),
(11, 2, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '23:30:00', '05:30:00', 1100.00, 'SCHEDULED', NOW()),

-- Mumbai -> Pune
(12, 6, 5, CURDATE(), '07:00:00', '10:30:00', 380.00, 'SCHEDULED', NOW()),
(13, 6, 5, CURDATE(), '16:00:00', '19:30:00', 380.00, 'SCHEDULED', NOW()),
(14, 3, 5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:30:00', '12:00:00', 480.00, 'SCHEDULED', NOW()),
(15, 6, 5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '17:30:00', '21:00:00', 380.00, 'SCHEDULED', NOW()),

-- Delhi -> Jaipur
(16, 5, 7, CURDATE(), '23:00:00', '04:00:00', 950.00, 'SCHEDULED', NOW()),
(17, 5, 7, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '06:00:00', '11:00:00', 950.00, 'SCHEDULED', NOW()),
(18, 5, 7, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '23:00:00', '04:00:00', 950.00, 'SCHEDULED', NOW()),

-- Hyderabad -> Vijayawada
(19, 1, 8, CURDATE(), '14:00:00', '19:15:00', 650.00, 'SCHEDULED', NOW()),
(20, 1, 8, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '19:15:00', 650.00, 'SCHEDULED', NOW()),

-- Bangalore -> Goa
(21, 2, 9, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:00:00', '07:00:00', 1750.00, 'SCHEDULED', NOW()),
(22, 4, 9, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:30:00', '08:30:00', 1850.00, 'SCHEDULED', NOW()),

-- Delhi -> Hyderabad
(23, 1, 10, CURDATE(), '18:00:00', '18:00:00', 2450.00, 'SCHEDULED', NOW()),
(24, 2, 10, CURDATE(), '20:30:00', '21:00:00', 2650.00, 'SCHEDULED', NOW()),
(25, 1, 10, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '18:00:00', '18:00:00', 2450.00, 'SCHEDULED', NOW()),
(26, 2, 10, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:30:00', '21:00:00', 2650.00, 'SCHEDULED', NOW()),
(27, 4, 10, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '17:30:00', '17:30:00', 2300.00, 'SCHEDULED', NOW()),
(28, 5, 10, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '19:00:00', '19:30:00', 2750.00, 'SCHEDULED', NOW()),
(29, 2, 10, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '21:15:00', '21:45:00', 2600.00, 'SCHEDULED', NOW())
ON DUPLICATE KEY UPDATE `fare` = VALUES(`fare`);

-- 5. Insert Sample Bookings for Demonstration
INSERT INTO `bookings` (`id`, `booking_reference`, `user_id`, `schedule_id`, `passenger_name`, `passenger_email`, `passenger_phone`, `total_seats`, `total_fare`, `booking_status`, `booking_date`) VALUES
(1, 'BRS-20261021-DEMO1', 2, 1, 'John Doe', 'john.doe@example.com', '+91 9123456780', 2, 2500.00, 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(2, 'BRS-20261021-DEMO2', 3, 2, 'Ikshita Sharma', 'ikshita@example.com', '+91 9848012345', 1, 1450.00, 'CONFIRMED', DATE_SUB(NOW(), INTERVAL 1 HOUR))
ON DUPLICATE KEY UPDATE `booking_reference` = VALUES(`booking_reference`);

-- 6. Insert Booked Seats for the Sample Bookings
-- Schedule 1 (Seater): Seats 1A and 1B are booked
INSERT INTO `booking_seats` (`id`, `booking_id`, `schedule_id`, `seat_number`, `passenger_gender`, `seat_fare`, `status`) VALUES
(1, 1, 1, '1A', 'MALE', 1250.00, 'BOOKED'),
(2, 1, 1, '1B', 'FEMALE', 1250.00, 'BOOKED'),
-- Schedule 2 (Sleeper): Lower Berth L1 is booked
(3, 2, 2, 'L1', 'FEMALE', 1450.00, 'BOOKED')
ON DUPLICATE KEY UPDATE `seat_number` = VALUES(`seat_number`);
