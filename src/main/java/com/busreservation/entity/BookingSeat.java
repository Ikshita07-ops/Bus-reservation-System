package com.busreservation.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "booking_seats")
public class BookingSeat implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String STATUS_BOOKED = "BOOKED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_id", nullable = false)
    private Schedule schedule;

    @Column(name = "seat_number", nullable = false, length = 10)
    private String seatNumber;

    @Column(name = "passenger_gender", length = 10)
    private String passengerGender = "ANY";

    @Column(name = "seat_fare", nullable = false, precision = 10, scale = 2)
    private BigDecimal seatFare;

    @Column(name = "status", nullable = false, length = 20)
    private String status = STATUS_BOOKED;

    public BookingSeat() {
    }

    public BookingSeat(Booking booking, Schedule schedule, String seatNumber, String passengerGender, BigDecimal seatFare) {
        this.booking = booking;
        this.schedule = schedule;
        this.seatNumber = seatNumber;
        this.passengerGender = passengerGender != null ? passengerGender : "ANY";
        this.seatFare = seatFare;
        this.status = STATUS_BOOKED;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getPassengerGender() {
        return passengerGender;
    }

    public void setPassengerGender(String passengerGender) {
        this.passengerGender = passengerGender;
    }

    public BigDecimal getSeatFare() {
        return seatFare;
    }

    public void setSeatFare(BigDecimal seatFare) {
        this.seatFare = seatFare;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
