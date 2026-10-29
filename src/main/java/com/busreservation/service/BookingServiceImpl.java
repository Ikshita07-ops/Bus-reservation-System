package com.busreservation.service;

import com.busreservation.dao.*;
import com.busreservation.dto.BookingRequestDto;
import com.busreservation.dto.DashboardStatsDto;
import com.busreservation.entity.*;
import com.busreservation.exception.InvalidBookingException;
import com.busreservation.exception.ResourceNotFoundException;
import com.busreservation.exception.SeatAlreadyBookedException;
import com.busreservation.exception.UnauthorizedException;
import com.busreservation.util.BookingReferenceGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Service
@Transactional
public class BookingServiceImpl implements BookingService {

    @Autowired
    private BookingDao bookingDao;

    @Autowired
    private BookingSeatDao bookingSeatDao;

    @Autowired
    private ScheduleDao scheduleDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private BusDao busDao;

    @Autowired
    private RouteDao routeDao;

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public synchronized Booking createBooking(BookingRequestDto request, Long userId) {
        if (request == null || request.getScheduleId() == null) {
            throw new InvalidBookingException("Invalid booking request: Schedule is required.");
        }
        if (request.getSeatNumbers() == null || request.getSeatNumbers().isEmpty()) {
            throw new InvalidBookingException("Please select at least one seat to proceed with booking.");
        }
        if (request.getPassengerName() == null || request.getPassengerName().trim().isEmpty()) {
            throw new InvalidBookingException("Passenger full name is required.");
        }
        if (request.getPassengerEmail() == null || request.getPassengerEmail().trim().isEmpty()) {
            throw new InvalidBookingException("Passenger email address is required.");
        }
        if (request.getPassengerPhone() == null || request.getPassengerPhone().trim().isEmpty()) {
            throw new InvalidBookingException("Passenger phone number is required.");
        }

        User user = userDao.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        // Use pessimistic write lock on schedule to serialize concurrent reservations for the same journey
        Schedule schedule = scheduleDao.findByIdForUpdate(request.getScheduleId())
                .orElseThrow(() -> new ResourceNotFoundException("Schedule not found with id: " + request.getScheduleId()));

        if (!schedule.isBookable()) {
            throw new InvalidBookingException("This schedule is no longer available for booking.");
        }

        // Concurrency check: verify none of the selected seats are already booked
        Set<String> alreadyBooked = bookingSeatDao.findBookedSeatNumbers(schedule.getId());
        for (String seatNumber : request.getSeatNumbers()) {
            if (alreadyBooked.contains(seatNumber.trim())) {
                throw new SeatAlreadyBookedException("Seat " + seatNumber + " is already booked by another customer. Please choose a different seat.");
            }
        }

        // Calculate total fare
        int seatCount = request.getSeatNumbers().size();
        BigDecimal totalFare = schedule.getFare().multiply(BigDecimal.valueOf(seatCount));

        // Create Booking
        Booking booking = new Booking();
        booking.setBookingReference(BookingReferenceGenerator.generateReference());
        booking.setUser(user);
        booking.setSchedule(schedule);
        booking.setPassengerName(request.getPassengerName().trim());
        booking.setPassengerEmail(request.getPassengerEmail().trim());
        booking.setPassengerPhone(request.getPassengerPhone().trim());
        booking.setTotalSeats(seatCount);
        booking.setTotalFare(totalFare);
        booking.setBookingStatus(Booking.STATUS_CONFIRMED);
        booking.setBookingDate(LocalDateTime.now());

        Booking savedBooking = bookingDao.save(booking);

        // Save individual seats
        for (String seatNumber : request.getSeatNumbers()) {
            String gender = "ANY";
            if (request.getPassengerGenders() != null && request.getPassengerGenders().containsKey(seatNumber)) {
                gender = request.getPassengerGenders().get(seatNumber);
            }
            BookingSeat seat = new BookingSeat(savedBooking, schedule, seatNumber.trim(), gender, schedule.getFare());
            bookingSeatDao.save(seat);
            savedBooking.addSeat(seat);
        }

        return savedBooking;
    }

    @Override
    public Booking cancelBooking(Long bookingId, Long userId, boolean isAdmin) {
        Booking booking = bookingDao.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        // Authorization check: non-admin user can only cancel their own booking
        if (!isAdmin && !booking.getUser().getId().equals(userId)) {
            throw new UnauthorizedException("You are not authorized to cancel this booking.");
        }

        if (booking.isCancelled()) {
            throw new InvalidBookingException("This booking is already cancelled.");
        }

        if (!booking.isEligibleForCancellation() && !isAdmin) {
            throw new InvalidBookingException("Bookings for past or departing journeys cannot be cancelled.");
        }

        // Update booking status
        booking.setBookingStatus(Booking.STATUS_CANCELLED);
        booking.setCancelledAt(LocalDateTime.now());
        bookingDao.update(booking);

        // Update booking seats to CANCELLED, immediately releasing them for new bookings
        bookingSeatDao.updateSeatStatusByBooking(bookingId, BookingSeat.STATUS_CANCELLED);

        return booking;
    }

    @Override
    @Transactional(readOnly = true)
    public Booking getBookingByReference(String reference) {
        return bookingDao.findByBookingReference(reference)
                .orElseThrow(() -> new ResourceNotFoundException("No booking found with reference: " + reference));
    }

    @Override
    @Transactional(readOnly = true)
    public Booking getBookingById(Long id) {
        return bookingDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Booking> getUserBookings(Long userId) {
        return bookingDao.findByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Booking> getAllBookings() {
        return bookingDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public DashboardStatsDto getDashboardStats() {
        DashboardStatsDto stats = new DashboardStatsDto();
        stats.setTotalBuses(busDao.countAll());
        stats.setTotalRoutes(routeDao.countAll());
        stats.setTotalSchedules(scheduleDao.countAll());
        stats.setTotalUsers(userDao.countAll());
        stats.setTotalBookings(bookingDao.countAll());
        stats.setActiveBookings(bookingDao.countByStatus(Booking.STATUS_CONFIRMED));
        stats.setCancelledBookings(bookingDao.countByStatus(Booking.STATUS_CANCELLED));
        stats.setTotalRevenue(bookingDao.calculateTotalRevenue());
        stats.setRecentBookings(bookingDao.findRecent(10));
        return stats;
    }
}
