package com.busreservation.dto;

import java.math.BigDecimal;

public class SeatDto {

    private String seatNumber;
    private int row;
    private int column;
    private String deck; // "LOWER" or "UPPER"
    private String type; // "SLEEPER" or "SEATER"
    private boolean isBooked;
    private String gender; // "MALE", "FEMALE", or "ANY"
    private BigDecimal fare;

    public SeatDto() {
    }

    public SeatDto(String seatNumber, int row, int column, String deck, String type, boolean isBooked, BigDecimal fare) {
        this.seatNumber = seatNumber;
        this.row = row;
        this.column = column;
        this.deck = deck;
        this.type = type;
        this.isBooked = isBooked;
        this.fare = fare;
        this.gender = "ANY";
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public int getRow() {
        return row;
    }

    public void setRow(int row) {
        this.row = row;
    }

    public int getColumn() {
        return column;
    }

    public void setColumn(int column) {
        this.column = column;
    }

    public String getDeck() {
        return deck;
    }

    public void setDeck(String deck) {
        this.deck = deck;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setBooked(boolean booked) {
        isBooked = booked;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public BigDecimal getFare() {
        return fare;
    }

    public void setFare(BigDecimal fare) {
        this.fare = fare;
    }
}
