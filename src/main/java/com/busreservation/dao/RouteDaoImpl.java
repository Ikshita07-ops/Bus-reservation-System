package com.busreservation.dao;

import com.busreservation.entity.Route;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class RouteDaoImpl implements RouteDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Route save(Route route) {
        sessionFactory.getCurrentSession().save(route);
        return route;
    }

    @Override
    public Route update(Route route) {
        sessionFactory.getCurrentSession().update(route);
        return route;
    }

    @Override
    public void delete(Route route) {
        sessionFactory.getCurrentSession().delete(route);
    }

    @Override
    public Optional<Route> findById(Long id) {
        Route route = sessionFactory.getCurrentSession().get(Route.class, id);
        return Optional.ofNullable(route);
    }

    @Override
    public Optional<Route> findBySourceAndDestination(String sourceCity, String destinationCity) {
        List<Route> list = sessionFactory.getCurrentSession()
                .createQuery("FROM Route WHERE LOWER(sourceCity) = LOWER(:s) AND LOWER(destinationCity) = LOWER(:d)", Route.class)
                .setParameter("s", sourceCity.trim())
                .setParameter("d", destinationCity.trim())
                .getResultList();
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public List<Route> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Route ORDER BY sourceCity ASC, destinationCity ASC", Route.class)
                .getResultList();
    }

    @Override
    public List<String> findAllSources() {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT DISTINCT r.sourceCity FROM Route r ORDER BY r.sourceCity ASC", String.class)
                .getResultList();
    }

    @Override
    public List<String> findAllDestinations() {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT DISTINCT r.destinationCity FROM Route r ORDER BY r.destinationCity ASC", String.class)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(r) FROM Route r", Long.class)
                .getSingleResult();
        return count != null ? count : 0L;
    }
}
