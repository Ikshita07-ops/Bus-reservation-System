package com.busreservation.service;

import com.busreservation.dto.BookingRequestDto;
import com.busreservation.dto.DashboardStatsDto;
import com.busreservation.entity.Booking;

import java.util.List;

public interface BookingService {
    Booking createBooking(BookingRequestDto request, Long userId);
    Booking cancelBooking(Long bookingId, Long userId, boolean isAdmin);
    Booking getBookingByReference(String reference);
    Booking getBookingById(Long id);
    List<Booking> getUserBookings(Long userId);
    List<Booking> getAllBookings();
    DashboardStatsDto getDashboardStats();
}
