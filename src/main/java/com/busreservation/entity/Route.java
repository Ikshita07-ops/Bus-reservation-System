package com.busreservation.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "routes", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"source_city", "destination_city"})
})
public class Route implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "source_city", nullable = false, length = 100)
    private String sourceCity;

    @Column(name = "destination_city", nullable = false, length = 100)
    private String destinationCity;

    @Column(name = "distance_km", nullable = false)
    private Integer distanceKm;

    @Column(name = "estimated_duration", nullable = false, length = 50)
    private String estimatedDuration; // e.g. "8 hrs 30 mins"

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public Route() {
    }

    public Route(String sourceCity, String destinationCity, Integer distanceKm, String estimatedDuration) {
        this.sourceCity = sourceCity;
        this.destinationCity = destinationCity;
        this.distanceKm = distanceKm;
        this.estimatedDuration = estimatedDuration;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public String getDisplayName() {
        return sourceCity + " to " + destinationCity;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSourceCity() {
        return sourceCity;
    }

    public void setSourceCity(String sourceCity) {
        this.sourceCity = sourceCity;
    }

    public String getDestinationCity() {
        return destinationCity;
    }

    public void setDestinationCity(String destinationCity) {
        this.destinationCity = destinationCity;
    }

    public Integer getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Integer distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(String estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
