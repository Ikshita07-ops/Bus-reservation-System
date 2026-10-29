package com.busreservation.dao;

import com.busreservation.entity.BookingSeat;
import java.util.List;
import java.util.Set;

public interface BookingSeatDao {
    BookingSeat save(BookingSeat seat);
    List<BookingSeat> findBookedSeatsBySchedule(Long scheduleId);
    Set<String> findBookedSeatNumbers(Long scheduleId);
    int countBookedSeats(Long scheduleId);
    void updateSeatStatusByBooking(Long bookingId, String status);
}
