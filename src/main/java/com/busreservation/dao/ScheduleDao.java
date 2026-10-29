package com.busreservation.dao;

import com.busreservation.entity.Schedule;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ScheduleDao {
    Schedule save(Schedule schedule);
    Schedule update(Schedule schedule);
    void delete(Schedule schedule);
    Optional<Schedule> findById(Long id);
    Optional<Schedule> findByIdForUpdate(Long id); // Pessimistic locking for concurrent reservation safety
    List<Schedule> search(String sourceCity, String destinationCity, LocalDate journeyDate, String busType);
    List<Schedule> findAll();
    List<Schedule> findByBusId(Long busId);
    List<Schedule> findByRouteId(Long routeId);
    long countAll();
}
