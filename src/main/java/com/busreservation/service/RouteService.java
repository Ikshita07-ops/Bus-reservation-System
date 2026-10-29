package com.busreservation.service;

import com.busreservation.entity.Route;
import java.util.List;

public interface RouteService {
    Route createRoute(Route route);
    Route updateRoute(Route route);
    void deleteRoute(Long id);
    Route getRouteById(Long id);
    List<Route> getAllRoutes();
    List<String> getAllSources();
    List<String> getAllDestinations();
    long getTotalRouteCount();
}
