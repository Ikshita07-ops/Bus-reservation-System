package com.busreservation.dao;

import com.busreservation.entity.Schedule;
import org.hibernate.LockMode;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class ScheduleDaoImpl implements ScheduleDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Schedule save(Schedule schedule) {
        sessionFactory.getCurrentSession().save(schedule);
        return schedule;
    }

    @Override
    public Schedule update(Schedule schedule) {
        sessionFactory.getCurrentSession().update(schedule);
        return schedule;
    }

    @Override
    public void delete(Schedule schedule) {
        sessionFactory.getCurrentSession().delete(schedule);
    }

    @Override
    public Optional<Schedule> findById(Long id) {
        Schedule schedule = sessionFactory.getCurrentSession().get(Schedule.class, id);
        return Optional.ofNullable(schedule);
    }

    @Override
    public Optional<Schedule> findByIdForUpdate(Long id) {
        Schedule schedule = sessionFactory.getCurrentSession().get(Schedule.class, id, LockMode.PESSIMISTIC_WRITE);
        return Optional.ofNullable(schedule);
    }

    @Override
    public List<Schedule> search(String sourceCity, String destinationCity, LocalDate journeyDate, String busType) {
        CriteriaBuilder cb = sessionFactory.getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<Schedule> cq = cb.createQuery(Schedule.class);
        Root<Schedule> root = cq.from(Schedule.class);

        // Fetch join route and bus
        root.fetch("route", JoinType.INNER);
        root.fetch("bus", JoinType.INNER);

        List<Predicate> predicates = new ArrayList<>();

        if (sourceCity != null && !sourceCity.trim().isEmpty()) {
            predicates.add(cb.equal(cb.lower(root.get("route").get("sourceCity")), sourceCity.trim().toLowerCase()));
        }

        if (destinationCity != null && !destinationCity.trim().isEmpty()) {
            predicates.add(cb.equal(cb.lower(root.get("route").get("destinationCity")), destinationCity.trim().toLowerCase()));
        }

        if (journeyDate != null) {
            predicates.add(cb.equal(root.get("journeyDate"), journeyDate));
        }

        if (busType != null && !busType.trim().isEmpty()) {
            predicates.add(cb.like(cb.lower(root.get("bus").get("busType")), "%" + busType.trim().toLowerCase() + "%"));
        }

        // Only active buses and scheduled status
        predicates.add(cb.equal(root.get("bus").get("isActive"), true));
        predicates.add(cb.equal(root.get("status"), Schedule.STATUS_SCHEDULED));

        cq.where(cb.and(predicates.toArray(new Predicate[0])));
        cq.orderBy(cb.asc(root.get("departureTime")));

        return sessionFactory.getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public List<Schedule> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Schedule s JOIN FETCH s.bus JOIN FETCH s.route ORDER BY s.journeyDate DESC, s.departureTime ASC", Schedule.class)
                .getResultList();
    }

    @Override
    public List<Schedule> findByBusId(Long busId) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Schedule s WHERE s.bus.id = :bid ORDER BY s.journeyDate DESC", Schedule.class)
                .setParameter("bid", busId)
                .getResultList();
    }

    @Override
    public List<Schedule> findByRouteId(Long routeId) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Schedule s WHERE s.route.id = :rid ORDER BY s.journeyDate DESC", Schedule.class)
                .setParameter("rid", routeId)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(s) FROM Schedule s", Long.class)
                .getSingleResult();
        return count != null ? count : 0L;
    }
}
