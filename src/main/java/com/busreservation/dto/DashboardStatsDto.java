package com.busreservation.dto;

import com.busreservation.entity.Booking;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class DashboardStatsDto {

    private long totalBuses;
    private long totalRoutes;
    private long totalSchedules;
    private long totalUsers;
    private long totalBookings;
    private long activeBookings;
    private long cancelledBookings;
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private List<Booking> recentBookings = new ArrayList<>();

    public DashboardStatsDto() {
    }

    public long getTotalBuses() {
        return totalBuses;
    }

    public void setTotalBuses(long totalBuses) {
        this.totalBuses = totalBuses;
    }

    public long getTotalRoutes() {
        return totalRoutes;
    }

    public void setTotalRoutes(long totalRoutes) {
        this.totalRoutes = totalRoutes;
    }

    public long getTotalSchedules() {
        return totalSchedules;
    }

    public void setTotalSchedules(long totalSchedules) {
        this.totalSchedules = totalSchedules;
    }

    public long getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(long totalUsers) {
        this.totalUsers = totalUsers;
    }

    public long getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(long totalBookings) {
        this.totalBookings = totalBookings;
    }

    public long getActiveBookings() {
        return activeBookings;
    }

    public void setActiveBookings(long activeBookings) {
        this.activeBookings = activeBookings;
    }

    public long getCancelledBookings() {
        return cancelledBookings;
    }

    public void setCancelledBookings(long cancelledBookings) {
        this.cancelledBookings = cancelledBookings;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue != null ? totalRevenue : BigDecimal.ZERO;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public List<Booking> getRecentBookings() {
        return recentBookings;
    }

    public void setRecentBookings(List<Booking> recentBookings) {
        this.recentBookings = recentBookings;
    }
}
