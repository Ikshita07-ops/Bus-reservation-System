package com.busreservation.service;

import com.busreservation.dto.BusSearchCriteria;
import com.busreservation.dto.SeatDto;
import com.busreservation.entity.Schedule;

import java.util.List;

public interface ScheduleService {
    Schedule createSchedule(Schedule schedule);
    Schedule updateSchedule(Schedule schedule);
    void deleteSchedule(Long id);
    Schedule getScheduleById(Long id);
    List<Schedule> searchSchedules(BusSearchCriteria criteria);
    List<Schedule> getAllSchedules();
    List<SeatDto> getAvailableSeatMap(Long scheduleId);
    int getAvailableSeatCount(Long scheduleId);
    long getTotalScheduleCount();
}
