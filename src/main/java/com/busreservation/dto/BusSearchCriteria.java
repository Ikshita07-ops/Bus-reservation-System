package com.busreservation.dto;

import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

public class BusSearchCriteria {

    private String source;
    private String destination;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate journeyDate;

    private String busType;

    public BusSearchCriteria() {
        this.journeyDate = LocalDate.now();
    }

    public BusSearchCriteria(String source, String destination, LocalDate journeyDate) {
        this.source = source;
        this.destination = destination;
        this.journeyDate = journeyDate != null ? journeyDate : LocalDate.now();
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source != null ? source.trim() : null;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination != null ? destination.trim() : null;
    }

    public LocalDate getJourneyDate() {
        return journeyDate;
    }

    public void setJourneyDate(LocalDate journeyDate) {
        this.journeyDate = journeyDate;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }
}
