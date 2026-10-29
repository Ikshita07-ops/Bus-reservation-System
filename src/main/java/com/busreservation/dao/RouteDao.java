package com.busreservation.dao;

import com.busreservation.entity.Route;
import java.util.List;
import java.util.Optional;

public interface RouteDao {
    Route save(Route route);
    Route update(Route route);
    void delete(Route route);
    Optional<Route> findById(Long id);
    Optional<Route> findBySourceAndDestination(String sourceCity, String destinationCity);
    List<Route> findAll();
    List<String> findAllSources();
    List<String> findAllDestinations();
    long countAll();
}
