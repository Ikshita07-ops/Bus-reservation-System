-- Bus Reservation Management System - Schema Definition
-- Target DBMS: MySQL 8.0+

CREATE DATABASE IF NOT EXISTS `bus_reservation_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bus_reservation_db`;

-- Drop existing tables in reverse dependency order if resetting
DROP TABLE IF EXISTS `booking_seats`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `schedules`;
DROP TABLE IF EXISTS `routes`;
DROP TABLE IF EXISTS `buses`;
DROP TABLE IF EXISTS `users`;

-- 1. Users Table
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `phone` VARCHAR(20) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(20) NOT NULL DEFAULT 'ROLE_CUSTOMER',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Buses Table
CREATE TABLE `buses` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `bus_number` VARCHAR(50) NOT NULL UNIQUE,
    `bus_name` VARCHAR(100) NOT NULL,
    `bus_type` VARCHAR(50) NOT NULL,
    `total_seats` INT NOT NULL DEFAULT 32,
    `amenities` VARCHAR(255) NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_bus_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Routes Table
CREATE TABLE `routes` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `source_city` VARCHAR(100) NOT NULL,
    `destination_city` VARCHAR(100) NOT NULL,
    `distance_km` INT NOT NULL,
    `estimated_duration` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_route_source_dest` (`source_city`, `destination_city`),
    INDEX `idx_route_cities` (`source_city`, `destination_city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Schedules Table
CREATE TABLE `schedules` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `bus_id` BIGINT NOT NULL,
    `route_id` BIGINT NOT NULL,
    `journey_date` DATE NOT NULL,
    `departure_time` TIME NOT NULL,
    `arrival_time` TIME NOT NULL,
    `fare` DECIMAL(10,2) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_sched_bus` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_sched_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX `idx_sched_search` (`journey_date`, `status`),
    INDEX `idx_sched_bus` (`bus_id`),
    INDEX `idx_sched_route` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bookings Table
CREATE TABLE `bookings` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `booking_reference` VARCHAR(30) NOT NULL UNIQUE,
    `user_id` BIGINT NOT NULL,
    `schedule_id` BIGINT NOT NULL,
    `passenger_name` VARCHAR(100) NOT NULL,
    `passenger_email` VARCHAR(100) NOT NULL,
    `passenger_phone` VARCHAR(20) NOT NULL,
    `total_seats` INT NOT NULL,
    `total_fare` DECIMAL(10,2) NOT NULL,
    `booking_status` VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
    `booking_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `cancelled_at` TIMESTAMP NULL,
    CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_booking_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX `idx_booking_ref` (`booking_reference`),
    INDEX `idx_booking_user` (`user_id`),
    INDEX `idx_booking_schedule` (`schedule_id`),
    INDEX `idx_booking_status` (`booking_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Booking Seats Table
CREATE TABLE `booking_seats` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` BIGINT NOT NULL,
    `schedule_id` BIGINT NOT NULL,
    `seat_number` VARCHAR(10) NOT NULL,
    `passenger_gender` VARCHAR(10) DEFAULT 'ANY',
    `seat_fare` DECIMAL(10,2) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
    CONSTRAINT `fk_seat_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_seat_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX `idx_seat_lookup` (`schedule_id`, `seat_number`, `status`),
    INDEX `idx_seat_booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
