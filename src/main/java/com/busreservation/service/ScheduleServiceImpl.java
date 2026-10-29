package com.busreservation.service;

import com.busreservation.dao.BookingSeatDao;
import com.busreservation.dao.ScheduleDao;
import com.busreservation.dto.BusSearchCriteria;
import com.busreservation.dto.SeatDto;
import com.busreservation.entity.Bus;
import com.busreservation.entity.Schedule;
import com.busreservation.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@Transactional
public class ScheduleServiceImpl implements ScheduleService {

    @Autowired
    private ScheduleDao scheduleDao;

    @Autowired
    private BookingSeatDao bookingSeatDao;

    @Override
    public Schedule createSchedule(Schedule schedule) {
        if (schedule.getStatus() == null || schedule.getStatus().isEmpty()) {
            schedule.setStatus(Schedule.STATUS_SCHEDULED);
        }
        return scheduleDao.save(schedule);
    }

    @Override
    public Schedule updateSchedule(Schedule schedule) {
        Schedule existing = getScheduleById(schedule.getId());
        existing.setBus(schedule.getBus());
        existing.setRoute(schedule.getRoute());
        existing.setJourneyDate(schedule.getJourneyDate());
        existing.setDepartureTime(schedule.getDepartureTime());
        existing.setArrivalTime(schedule.getArrivalTime());
        existing.setFare(schedule.getFare());
        existing.setStatus(schedule.getStatus());
        return scheduleDao.update(existing);
    }

    @Override
    public void deleteSchedule(Long id) {
        Schedule schedule = getScheduleById(id);
        scheduleDao.delete(schedule);
    }

    @Override
    @Transactional(readOnly = true)
    public Schedule getScheduleById(Long id) {
        Schedule schedule = scheduleDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Schedule not found with id: " + id));
        int booked = bookingSeatDao.countBookedSeats(schedule.getId());
        int total = schedule.getBus() != null ? schedule.getBus().getTotalSeats() : 32;
        schedule.setAvailableSeats(Math.max(0, total - booked));
        return schedule;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Schedule> searchSchedules(BusSearchCriteria criteria) {
        LocalDate searchDate = criteria.getJourneyDate() != null ? criteria.getJourneyDate() : LocalDate.now();
        List<Schedule> list = scheduleDao.search(
                criteria.getSource(),
                criteria.getDestination(),
                searchDate,
                criteria.getBusType()
        );

        for (Schedule schedule : list) {
            int booked = bookingSeatDao.countBookedSeats(schedule.getId());
            int total = schedule.getBus() != null ? schedule.getBus().getTotalSeats() : 32;
            schedule.setAvailableSeats(Math.max(0, total - booked));
        }

        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Schedule> getAllSchedules() {
        List<Schedule> list = scheduleDao.findAll();
        for (Schedule schedule : list) {
            int booked = bookingSeatDao.countBookedSeats(schedule.getId());
            int total = schedule.getBus() != null ? schedule.getBus().getTotalSeats() : 32;
            schedule.setAvailableSeats(Math.max(0, total - booked));
        }
        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public List<SeatDto> getAvailableSeatMap(Long scheduleId) {
        Schedule schedule = getScheduleById(scheduleId);
        Bus bus = schedule.getBus();
        int totalSeats = (bus != null && bus.getTotalSeats() != null) ? bus.getTotalSeats() : 32;
        boolean isSleeper = bus != null && bus.getBusType() != null && bus.getBusType().toLowerCase().contains("sleeper");

        Set<String> bookedSeats = bookingSeatDao.findBookedSeatNumbers(scheduleId);
        List<SeatDto> seatList = new ArrayList<>();

        if (isSleeper) {
            // Sleeper layout: 2+1 layout, Lower deck & Upper deck
            // e.g. 30 seats total -> 15 Lower (L1..L15), 15 Upper (U1..U15)
            int half = totalSeats / 2;
            int rows = (int) Math.ceil(half / 3.0);

            // Lower Deck
            int seatIdx = 1;
            for (int r = 1; r <= rows && seatIdx <= half; r++) {
                // Column 1 (Single)
                String sNum = "L" + seatIdx;
                seatList.add(new SeatDto(sNum, r, 1, "LOWER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                seatIdx++;
                // Column 2 (Double left)
                if (seatIdx <= half) {
                    sNum = "L" + seatIdx;
                    seatList.add(new SeatDto(sNum, r, 2, "LOWER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                    seatIdx++;
                }
                // Column 3 (Double right)
                if (seatIdx <= half) {
                    sNum = "L" + seatIdx;
                    seatList.add(new SeatDto(sNum, r, 3, "LOWER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                    seatIdx++;
                }
            }

            // Upper Deck
            seatIdx = 1;
            for (int r = 1; r <= rows && seatIdx <= (totalSeats - half); r++) {
                String sNum = "U" + seatIdx;
                seatList.add(new SeatDto(sNum, r, 1, "UPPER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                seatIdx++;
                if (seatIdx <= (totalSeats - half)) {
                    sNum = "U" + seatIdx;
                    seatList.add(new SeatDto(sNum, r, 2, "UPPER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                    seatIdx++;
                }
                if (seatIdx <= (totalSeats - half)) {
                    sNum = "U" + seatIdx;
                    seatList.add(new SeatDto(sNum, r, 3, "UPPER", "SLEEPER", bookedSeats.contains(sNum), schedule.getFare()));
                    seatIdx++;
                }
            }
        } else {
            // Seater layout: 2+2 layout with aisle in between
            // Letters A, B (left), C, D (right)
            int rows = (int) Math.ceil(totalSeats / 4.0);
            int count = 0;
            String[] cols = new String[]{"A", "B", "C", "D"};

            for (int r = 1; r <= rows && count < totalSeats; r++) {
                for (int c = 0; c < 4 && count < totalSeats; c++) {
                    String sNum = r + cols[c];
                    seatList.add(new SeatDto(sNum, r, c + 1, "LOWER", "SEATER", bookedSeats.contains(sNum), schedule.getFare()));
                    count++;
                }
            }
        }

        return seatList;
    }

    @Override
    @Transactional(readOnly = true)
    public int getAvailableSeatCount(Long scheduleId) {
        Schedule schedule = scheduleDao.findById(scheduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Schedule not found with id: " + scheduleId));
        int booked = bookingSeatDao.countBookedSeats(scheduleId);
        int total = schedule.getBus() != null ? schedule.getBus().getTotalSeats() : 32;
        return Math.max(0, total - booked);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalScheduleCount() {
        return scheduleDao.countAll();
    }
}
