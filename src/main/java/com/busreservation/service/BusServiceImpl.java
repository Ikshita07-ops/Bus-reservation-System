package com.busreservation.service;

import com.busreservation.dao.BusDao;
import com.busreservation.entity.Bus;
import com.busreservation.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class BusServiceImpl implements BusService {

    @Autowired
    private BusDao busDao;

    @Override
    public Bus createBus(Bus bus) {
        if (bus.getTotalSeats() == null || bus.getTotalSeats() <= 0) {
            bus.setTotalSeats(32);
        }
        if (bus.getIsActive() == null) {
            bus.setIsActive(true);
        }
        return busDao.save(bus);
    }

    @Override
    public Bus updateBus(Bus bus) {
        Bus existing = getBusById(bus.getId());
        existing.setBusNumber(bus.getBusNumber());
        existing.setBusName(bus.getBusName());
        existing.setBusType(bus.getBusType());
        existing.setTotalSeats(bus.getTotalSeats());
        existing.setAmenities(bus.getAmenities());
        existing.setIsActive(bus.getIsActive());
        return busDao.update(existing);
    }

    @Override
    public void deleteBus(Long id) {
        Bus bus = getBusById(id);
        busDao.delete(bus);
    }

    @Override
    @Transactional(readOnly = true)
    public Bus getBusById(Long id) {
        return busDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Bus not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bus> getAllBuses() {
        return busDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bus> getActiveBuses() {
        return busDao.findAllActive();
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalBusCount() {
        return busDao.countAll();
    }
}
