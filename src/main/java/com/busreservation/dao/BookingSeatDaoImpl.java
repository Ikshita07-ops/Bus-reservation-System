package com.busreservation.dao;

import com.busreservation.entity.BookingSeat;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Repository
public class BookingSeatDaoImpl implements BookingSeatDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public BookingSeat save(BookingSeat seat) {
        sessionFactory.getCurrentSession().save(seat);
        return seat;
    }

    @Override
    public List<BookingSeat> findBookedSeatsBySchedule(Long scheduleId) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM BookingSeat bs WHERE bs.schedule.id = :sid AND bs.status = :st", BookingSeat.class)
                .setParameter("sid", scheduleId)
                .setParameter("st", BookingSeat.STATUS_BOOKED)
                .getResultList();
    }

    @Override
    public Set<String> findBookedSeatNumbers(Long scheduleId) {
        List<String> list = sessionFactory.getCurrentSession()
                .createQuery("SELECT bs.seatNumber FROM BookingSeat bs WHERE bs.schedule.id = :sid AND bs.status = :st", String.class)
                .setParameter("sid", scheduleId)
                .setParameter("st", BookingSeat.STATUS_BOOKED)
                .getResultList();
        return new HashSet<>(list);
    }

    @Override
    public int countBookedSeats(Long scheduleId) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(bs) FROM BookingSeat bs WHERE bs.schedule.id = :sid AND bs.status = :st", Long.class)
                .setParameter("sid", scheduleId)
                .setParameter("st", BookingSeat.STATUS_BOOKED)
                .getSingleResult();
        return count != null ? count.intValue() : 0;
    }

    @Override
    public void updateSeatStatusByBooking(Long bookingId, String status) {
        sessionFactory.getCurrentSession()
                .createQuery("UPDATE BookingSeat bs SET bs.status = :st WHERE bs.booking.id = :bid")
                .setParameter("st", status)
                .setParameter("bid", bookingId)
                .executeUpdate();
    }
}
