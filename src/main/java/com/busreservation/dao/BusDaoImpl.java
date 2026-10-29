package com.busreservation.dao;

import com.busreservation.entity.Bus;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class BusDaoImpl implements BusDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Bus save(Bus bus) {
        sessionFactory.getCurrentSession().save(bus);
        return bus;
    }

    @Override
    public Bus update(Bus bus) {
        sessionFactory.getCurrentSession().update(bus);
        return bus;
    }

    @Override
    public void delete(Bus bus) {
        sessionFactory.getCurrentSession().delete(bus);
    }

    @Override
    public Optional<Bus> findById(Long id) {
        Bus bus = sessionFactory.getCurrentSession().get(Bus.class, id);
        return Optional.ofNullable(bus);
    }

    @Override
    public Optional<Bus> findByBusNumber(String busNumber) {
        List<Bus> list = sessionFactory.getCurrentSession()
                .createQuery("FROM Bus WHERE LOWER(busNumber) = LOWER(:bn)", Bus.class)
                .setParameter("bn", busNumber.trim())
                .getResultList();
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public List<Bus> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Bus ORDER BY id DESC", Bus.class)
                .getResultList();
    }

    @Override
    public List<Bus> findAllActive() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Bus WHERE isActive = true ORDER BY busName ASC", Bus.class)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(b) FROM Bus b", Long.class)
                .getSingleResult();
        return count != null ? count : 0L;
    }
}
