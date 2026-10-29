package com.busreservation.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Entity
@Table(name = "bookings")
public class Booking implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String STATUS_CONFIRMED = "CONFIRMED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    private static final DateTimeFormatter DATE_TIME_FMT = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "booking_reference", nullable = false, unique = true, length = 30)
    private String bookingReference;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "schedule_id", nullable = false)
    private Schedule schedule;

    @Column(name = "passenger_name", nullable = false, length = 100)
    private String passengerName;

    @Column(name = "passenger_email", nullable = false, length = 100)
    private String passengerEmail;

    @Column(name = "passenger_phone", nullable = false, length = 20)
    private String passengerPhone;

    @Column(name = "total_seats", nullable = false)
    private Integer totalSeats;

    @Column(name = "total_fare", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalFare;

    @Column(name = "booking_status", nullable = false, length = 20)
    private String bookingStatus = STATUS_CONFIRMED;

    @Column(name = "booking_date", updatable = false)
    private LocalDateTime bookingDate;

    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, fetch = FetchType.EAGER, orphanRemoval = true)
    private List<BookingSeat> seats = new ArrayList<>();

    public Booking() {
    }

    @PrePersist
    protected void onCreate() {
        this.bookingDate = LocalDateTime.now();
    }

    public boolean isConfirmed() {
        return STATUS_CONFIRMED.equalsIgnoreCase(this.bookingStatus);
    }

    public boolean isCancelled() {
        return STATUS_CANCELLED.equalsIgnoreCase(this.bookingStatus);
    }

    public boolean isEligibleForCancellation() {
        if (!isConfirmed()) {
            return false;
        }
        if (schedule == null || schedule.getJourneyDate() == null) {
            return false;
        }
        LocalDateTime journeyDateTime = LocalDateTime.of(schedule.getJourneyDate(), schedule.getDepartureTime());
        // Can cancel if journey departure is in the future
        return LocalDateTime.now().isBefore(journeyDateTime);
    }

    public String getSeatNumbersAsString() {
        if (seats == null || seats.isEmpty()) {
            return "";
        }
        return seats.stream()
                .map(BookingSeat::getSeatNumber)
                .collect(Collectors.joining(", "));
    }

    public String getFormattedBookingDate() {
        return bookingDate != null ? bookingDate.format(DATE_TIME_FMT) : "";
    }

    public String getFormattedCancelledAt() {
        return cancelledAt != null ? cancelledAt.format(DATE_TIME_FMT) : "";
    }

    public void addSeat(BookingSeat seat) {
        seats.add(seat);
        seat.setBooking(this);
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBookingReference() {
        return bookingReference;
    }

    public void setBookingReference(String bookingReference) {
        this.bookingReference = bookingReference;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public String getPassengerEmail() {
        return passengerEmail;
    }

    public void setPassengerEmail(String passengerEmail) {
        this.passengerEmail = passengerEmail;
    }

    public String getPassengerPhone() {
        return passengerPhone;
    }

    public void setPassengerPhone(String passengerPhone) {
        this.passengerPhone = passengerPhone;
    }

    public Integer getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(Integer totalSeats) {
        this.totalSeats = totalSeats;
    }

    public BigDecimal getTotalFare() {
        return totalFare;
    }

    public void setTotalFare(BigDecimal totalFare) {
        this.totalFare = totalFare;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public List<BookingSeat> getSeats() {
        return seats;
    }

    public void setSeats(List<BookingSeat> seats) {
        this.seats = seats;
    }
}
