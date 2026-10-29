package com.busreservation.controller;

import com.busreservation.dto.BusSearchCriteria;
import com.busreservation.entity.Route;
import com.busreservation.service.RouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private RouteService routeService;

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        List<String> sources = routeService.getAllSources();
        List<String> destinations = routeService.getAllDestinations();
        List<Route> popularRoutes = routeService.getAllRoutes();

        model.addAttribute("sources", sources);
        model.addAttribute("destinations", destinations);
        model.addAttribute("popularRoutes", popularRoutes);
        model.addAttribute("searchCriteria", new BusSearchCriteria(null, null, LocalDate.now()));
        model.addAttribute("today", LocalDate.now().toString());

        return "index";
    }

    @GetMapping("/about")
    public String about() {
        return "common/about";
    }

    @GetMapping("/contact")
    public String contact() {
        return "common/contact";
    }
}
