package com.busreservation.service;

import com.busreservation.dao.RouteDao;
import com.busreservation.entity.Route;
import com.busreservation.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RouteServiceImpl implements RouteService {

    @Autowired
    private RouteDao routeDao;

    @Override
    public Route createRoute(Route route) {
        route.setSourceCity(route.getSourceCity().trim());
        route.setDestinationCity(route.getDestinationCity().trim());
        return routeDao.save(route);
    }

    @Override
    public Route updateRoute(Route route) {
        Route existing = getRouteById(route.getId());
        existing.setSourceCity(route.getSourceCity().trim());
        existing.setDestinationCity(route.getDestinationCity().trim());
        existing.setDistanceKm(route.getDistanceKm());
        existing.setEstimatedDuration(route.getEstimatedDuration());
        return routeDao.update(existing);
    }

    @Override
    public void deleteRoute(Long id) {
        Route route = getRouteById(id);
        routeDao.delete(route);
    }

    @Override
    @Transactional(readOnly = true)
    public Route getRouteById(Long id) {
        return routeDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Route not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Route> getAllRoutes() {
        return routeDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllSources() {
        return routeDao.findAllSources();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllDestinations() {
        return routeDao.findAllDestinations();
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalRouteCount() {
        return routeDao.countAll();
    }
}
