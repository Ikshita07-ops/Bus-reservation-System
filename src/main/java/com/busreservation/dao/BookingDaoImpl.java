package com.busreservation.dao;

import com.busreservation.entity.Booking;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public class BookingDaoImpl implements BookingDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Booking save(Booking booking) {
        sessionFactory.getCurrentSession().save(booking);
        return booking;
    }

    @Override
    public Booking update(Booking booking) {
        sessionFactory.getCurrentSession().update(booking);
        return booking;
    }

    @Override
    public void delete(Booking booking) {
        sessionFactory.getCurrentSession().delete(booking);
    }

    @Override
    public Optional<Booking> findById(Long id) {
        Booking booking = sessionFactory.getCurrentSession().get(Booking.class, id);
        return Optional.ofNullable(booking);
    }

    @Override
    public Optional<Booking> findByBookingReference(String reference) {
        List<Booking> list = sessionFactory.getCurrentSession()
                .createQuery("FROM Booking b JOIN FETCH b.schedule s JOIN FETCH s.bus JOIN FETCH s.route JOIN FETCH b.user WHERE UPPER(b.bookingReference) = UPPER(:ref)", Booking.class)
                .setParameter("ref", reference.trim())
                .getResultList();
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public List<Booking> findByUserId(Long userId) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Booking b JOIN FETCH b.schedule s JOIN FETCH s.bus JOIN FETCH s.route WHERE b.user.id = :uid ORDER BY b.bookingDate DESC", Booking.class)
                .setParameter("uid", userId)
                .getResultList();
    }

    @Override
    public List<Booking> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Booking b JOIN FETCH b.schedule s JOIN FETCH s.bus JOIN FETCH s.route JOIN FETCH b.user ORDER BY b.bookingDate DESC", Booking.class)
                .getResultList();
    }

    @Override
    public List<Booking> findRecent(int limit) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Booking b JOIN FETCH b.schedule s JOIN FETCH s.bus JOIN FETCH s.route JOIN FETCH b.user ORDER BY b.bookingDate DESC", Booking.class)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(b) FROM Booking b", Long.class)
                .getSingleResult();
        return count != null ? count : 0L;
    }

    @Override
    public long countByStatus(String status) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(b) FROM Booking b WHERE b.bookingStatus = :st", Long.class)
                .setParameter("st", status)
                .getSingleResult();
        return count != null ? count : 0L;
    }

    @Override
    public BigDecimal calculateTotalRevenue() {
        BigDecimal total = sessionFactory.getCurrentSession()
                .createQuery("SELECT SUM(b.totalFare) FROM Booking b WHERE b.bookingStatus = :st", BigDecimal.class)
                .setParameter("st", Booking.STATUS_CONFIRMED)
                .getSingleResult();
        return total != null ? total : BigDecimal.ZERO;
    }
}
