package com.busreservation.dao;

import com.busreservation.entity.Bus;
import java.util.List;
import java.util.Optional;

public interface BusDao {
    Bus save(Bus bus);
    Bus update(Bus bus);
    void delete(Bus bus);
    Optional<Bus> findById(Long id);
    Optional<Bus> findByBusNumber(String busNumber);
    List<Bus> findAll();
    List<Bus> findAllActive();
    long countAll();
}
