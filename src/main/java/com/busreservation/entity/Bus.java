package com.busreservation.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "buses")
public class Bus implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "bus_number", nullable = false, unique = true, length = 50)
    private String busNumber;

    @Column(name = "bus_name", nullable = false, length = 100)
    private String busName;

    @Column(name = "bus_type", nullable = false, length = 50)
    private String busType; // e.g. "AC Sleeper 2+1", "AC Seater 2+2", "Volvo Multi-Axle"

    @Column(name = "total_seats", nullable = false)
    private Integer totalSeats = 32;

    @Column(name = "amenities", length = 255)
    private String amenities;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public Bus() {
    }

    public Bus(String busNumber, String busName, String busType, Integer totalSeats, String amenities) {
        this.busNumber = busNumber;
        this.busName = busName;
        this.busType = busType;
        this.totalSeats = totalSeats != null ? totalSeats : 32;
        this.amenities = amenities;
        this.isActive = true;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getBusName() {
        return busName;
    }

    public void setBusName(String busName) {
        this.busName = busName;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public Integer getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(Integer totalSeats) {
        this.totalSeats = totalSeats;
    }

    public String getAmenities() {
        return amenities;
    }

    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
