package com.busreservation.service;

import com.busreservation.entity.Bus;
import java.util.List;

public interface BusService {
    Bus createBus(Bus bus);
    Bus updateBus(Bus bus);
    void deleteBus(Long id);
    Bus getBusById(Long id);
    List<Bus> getAllBuses();
    List<Bus> getActiveBuses();
    long getTotalBusCount();
}
