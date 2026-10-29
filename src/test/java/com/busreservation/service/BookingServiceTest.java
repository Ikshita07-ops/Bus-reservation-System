package com.busreservation.service;

import com.busreservation.dao.*;
import com.busreservation.dto.BookingRequestDto;
import com.busreservation.entity.*;
import com.busreservation.exception.InvalidBookingException;
import com.busreservation.exception.SeatAlreadyBookedException;
import com.busreservation.exception.UnauthorizedException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BookingServiceTest {

    @Mock
    private BookingDao bookingDao;

    @Mock
    private BookingSeatDao bookingSeatDao;

    @Mock
    private ScheduleDao scheduleDao;

    @Mock
    private UserDao userDao;

    @Mock
    private BusDao busDao;

    @Mock
    private RouteDao routeDao;

    @InjectMocks
    private BookingServiceImpl bookingService;

    private User sampleUser;
    private Bus sampleBus;
    private Route sampleRoute;
    private Schedule sampleSchedule;

    @BeforeEach
    public void setup() {
        sampleUser = new User("John Doe", "john@example.com", "9999999999", "hashed", User.ROLE_CUSTOMER);
        sampleUser.setId(10L);

        sampleBus = new Bus("KA01A1234", "Super Express", "Volvo AC (2+2)", 32, "WiFi");
        sampleBus.setId(1L);

        sampleRoute = new Route("CityA", "CityB", 300, "5 hrs");
        sampleRoute.setId(1L);

        sampleSchedule = new Schedule(sampleBus, sampleRoute, LocalDate.now().plusDays(2), LocalTime.of(10, 0), LocalTime.of(15, 0), new BigDecimal("500.00"));
        sampleSchedule.setId(100L);
    }

    @Test
    public void testCreateBookingSuccess() {
        BookingRequestDto dto = new BookingRequestDto();
        dto.setScheduleId(100L);
        dto.setSeatNumbers(Arrays.asList("1A", "1B"));
        dto.setPassengerName("John Doe");
        dto.setPassengerEmail("john@example.com");
        dto.setPassengerPhone("9999999999");

        when(userDao.findById(10L)).thenReturn(Optional.of(sampleUser));
        when(scheduleDao.findByIdForUpdate(100L)).thenReturn(Optional.of(sampleSchedule));
        when(bookingSeatDao.findBookedSeatNumbers(100L)).thenReturn(new HashSet<>());
        when(bookingDao.save(any(Booking.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Booking booking = bookingService.createBooking(dto, 10L);

        assertNotNull(booking);
        assertNotNull(booking.getBookingReference());
        assertTrue(booking.getBookingReference().startsWith("BRS-"));
        assertEquals(2, booking.getTotalSeats());
        assertEquals(new BigDecimal("1000.00"), booking.getTotalFare());
        assertEquals(Booking.STATUS_CONFIRMED, booking.getBookingStatus());
        verify(bookingSeatDao, times(2)).save(any(BookingSeat.class));
    }

    @Test
    public void testCreateBookingDuplicateSeatThrowsException() {
        BookingRequestDto dto = new BookingRequestDto();
        dto.setScheduleId(100L);
        dto.setSeatNumbers(Arrays.asList("1A", "1B"));
        dto.setPassengerName("John Doe");
        dto.setPassengerEmail("john@example.com");
        dto.setPassengerPhone("9999999999");

        Set<String> alreadyBooked = new HashSet<>(Collections.singletonList("1A"));

        when(userDao.findById(10L)).thenReturn(Optional.of(sampleUser));
        when(scheduleDao.findByIdForUpdate(100L)).thenReturn(Optional.of(sampleSchedule));
        when(bookingSeatDao.findBookedSeatNumbers(100L)).thenReturn(alreadyBooked);

        assertThrows(SeatAlreadyBookedException.class, () -> {
            bookingService.createBooking(dto, 10L);
        });

        verify(bookingDao, never()).save(any(Booking.class));
    }

    @Test
    public void testCancelBookingSuccess() {
        Booking booking = new Booking();
        booking.setId(500L);
        booking.setUser(sampleUser);
        booking.setSchedule(sampleSchedule);
        booking.setBookingStatus(Booking.STATUS_CONFIRMED);

        when(bookingDao.findById(500L)).thenReturn(Optional.of(booking));

        Booking cancelled = bookingService.cancelBooking(500L, 10L, false);

        assertEquals(Booking.STATUS_CANCELLED, cancelled.getBookingStatus());
        assertNotNull(cancelled.getCancelledAt());
        verify(bookingSeatDao, times(1)).updateSeatStatusByBooking(500L, BookingSeat.STATUS_CANCELLED);
    }

    @Test
    public void testCancelBookingUnauthorizedThrowsException() {
        Booking booking = new Booking();
        booking.setId(500L);
        booking.setUser(sampleUser); // User id is 10L
        booking.setSchedule(sampleSchedule);
        booking.setBookingStatus(Booking.STATUS_CONFIRMED);

        when(bookingDao.findById(500L)).thenReturn(Optional.of(booking));

        // Different user trying to cancel
        assertThrows(UnauthorizedException.class, () -> {
            bookingService.cancelBooking(500L, 999L, false);
        });

        verify(bookingDao, never()).update(any(Booking.class));
    }
}
