package com.busreservation.controller;

import com.busreservation.dto.BusSearchCriteria;
import com.busreservation.dto.SeatDto;
import com.busreservation.entity.Schedule;
import com.busreservation.service.RouteService;
import com.busreservation.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Controller
public class BusSearchController {

    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private RouteService routeService;

    @GetMapping("/search")
    public String searchBuses(@RequestParam(value = "source", required = false) String source,
                              @RequestParam(value = "destination", required = false) String destination,
                              @RequestParam(value = "journeyDate", required = false)
                              @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate journeyDate,
                              @RequestParam(value = "busType", required = false) String busType,
                              Model model) {
        if (journeyDate == null) {
            journeyDate = LocalDate.now();
        }

        BusSearchCriteria criteria = new BusSearchCriteria(source, destination, journeyDate);
        criteria.setBusType(busType);

        List<Schedule> schedules = scheduleService.searchSchedules(criteria);

        model.addAttribute("criteria", criteria);
        model.addAttribute("schedules", schedules);
        model.addAttribute("sources", routeService.getAllSources());
        model.addAttribute("destinations", routeService.getAllDestinations());
        model.addAttribute("today", LocalDate.now().toString());

        return "search/results";
    }

    @GetMapping("/search/seat-layout/{scheduleId}")
    public String viewSeatLayout(@PathVariable("scheduleId") Long scheduleId, Model model) {
        Schedule schedule = scheduleService.getScheduleById(scheduleId);
        List<SeatDto> seatMap = scheduleService.getAvailableSeatMap(scheduleId);

        model.addAttribute("schedule", schedule);
        model.addAttribute("seatMap", seatMap);
        model.addAttribute("availableCount", scheduleService.getAvailableSeatCount(scheduleId));

        return "search/seat-selection";
    }

    @GetMapping("/api/schedules/{scheduleId}/seats")
    @ResponseBody
    public List<SeatDto> getSeatMapApi(@PathVariable("scheduleId") Long scheduleId) {
        return scheduleService.getAvailableSeatMap(scheduleId);
    }
}
