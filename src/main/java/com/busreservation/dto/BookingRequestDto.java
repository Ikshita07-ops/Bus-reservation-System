package com.busreservation.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingRequestDto {

    private Long scheduleId;
    private List<String> seatNumbers = new ArrayList<>();
    private String passengerName;
    private String passengerEmail;
    private String passengerPhone;
    private Map<String, String> passengerGenders = new HashMap<>();

    public BookingRequestDto() {
    }

    public Long getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(Long scheduleId) {
        this.scheduleId = scheduleId;
    }

    public List<String> getSeatNumbers() {
        return seatNumbers;
    }

    public void setSeatNumbers(List<String> seatNumbers) {
        this.seatNumbers = seatNumbers;
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

    public Map<String, String> getPassengerGenders() {
        return passengerGenders;
    }

    public void setPassengerGenders(Map<String, String> passengerGenders) {
        this.passengerGenders = passengerGenders;
    }
}
