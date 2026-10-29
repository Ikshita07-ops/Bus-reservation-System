package com.busreservation.dao;

import com.busreservation.entity.Booking;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface BookingDao {
    Booking save(Booking booking);
    Booking update(Booking booking);
    void delete(Booking booking);
    Optional<Booking> findById(Long id);
    Optional<Booking> findByBookingReference(String reference);
    List<Booking> findByUserId(Long userId);
    List<Booking> findAll();
    List<Booking> findRecent(int limit);
    long countAll();
    long countByStatus(String status);
    BigDecimal calculateTotalRevenue();
}
