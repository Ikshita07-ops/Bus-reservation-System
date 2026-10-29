package com.busreservation.controller;

import com.busreservation.config.SecurityInterceptor;
import com.busreservation.dto.DashboardStatsDto;
import com.busreservation.entity.*;
import com.busreservation.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private BusService busService;

    @Autowired
    private RouteService routeService;

    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private UserService userService;

    // 1. Dashboard
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        DashboardStatsDto stats = bookingService.getDashboardStats();
        model.addAttribute("stats", stats);
        return "admin/dashboard";
    }

    // 2. Bus Management
    @GetMapping("/buses")
    public String listBuses(Model model) {
        List<Bus> buses = busService.getAllBuses();
        model.addAttribute("buses", buses);
        return "admin/buses";
    }

    @GetMapping("/buses/new")
    public String newBusForm(Model model) {
        model.addAttribute("bus", new Bus());
        model.addAttribute("isEdit", false);
        return "admin/bus-form";
    }

    @PostMapping("/buses/new")
    public String saveBus(@ModelAttribute("bus") Bus bus, RedirectAttributes redirectAttributes) {
        try {
            busService.createBus(bus);
            redirectAttributes.addFlashAttribute("successMessage", "Bus added successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error saving bus: " + e.getMessage());
        }
        return "redirect:/admin/buses";
    }

    @GetMapping("/buses/edit/{id}")
    public String editBusForm(@PathVariable("id") Long id, Model model) {
        Bus bus = busService.getBusById(id);
        model.addAttribute("bus", bus);
        model.addAttribute("isEdit", true);
        return "admin/bus-form";
    }

    @PostMapping("/buses/edit/{id}")
    public String updateBus(@PathVariable("id") Long id, @ModelAttribute("bus") Bus bus, RedirectAttributes redirectAttributes) {
        try {
            bus.setId(id);
            busService.updateBus(bus);
            redirectAttributes.addFlashAttribute("successMessage", "Bus updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating bus: " + e.getMessage());
        }
        return "redirect:/admin/buses";
    }

    @RequestMapping(value = "/buses/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String deleteBus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            busService.deleteBus(id);
            redirectAttributes.addFlashAttribute("successMessage", "Bus deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete bus. It may be linked to existing schedules or bookings.");
        }
        return "redirect:/admin/buses";
    }

    // 3. Route Management
    @GetMapping("/routes")
    public String listRoutes(Model model) {
        List<Route> routes = routeService.getAllRoutes();
        model.addAttribute("routes", routes);
        return "admin/routes";
    }

    @GetMapping("/routes/new")
    public String newRouteForm(Model model) {
        model.addAttribute("route", new Route());
        model.addAttribute("isEdit", false);
        return "admin/route-form";
    }

    @PostMapping("/routes/new")
    public String saveRoute(@ModelAttribute("route") Route route, RedirectAttributes redirectAttributes) {
        try {
            routeService.createRoute(route);
            redirectAttributes.addFlashAttribute("successMessage", "Route added successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error saving route: " + e.getMessage());
        }
        return "redirect:/admin/routes";
    }

    @GetMapping("/routes/edit/{id}")
    public String editRouteForm(@PathVariable("id") Long id, Model model) {
        Route route = routeService.getRouteById(id);
        model.addAttribute("route", route);
        model.addAttribute("isEdit", true);
        return "admin/route-form";
    }

    @PostMapping("/routes/edit/{id}")
    public String updateRoute(@PathVariable("id") Long id, @ModelAttribute("route") Route route, RedirectAttributes redirectAttributes) {
        try {
            route.setId(id);
            routeService.updateRoute(route);
            redirectAttributes.addFlashAttribute("successMessage", "Route updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating route: " + e.getMessage());
        }
        return "redirect:/admin/routes";
    }

    @RequestMapping(value = "/routes/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String deleteRoute(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            routeService.deleteRoute(id);
            redirectAttributes.addFlashAttribute("successMessage", "Route deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete route. It may have existing schedules assigned to it.");
        }
        return "redirect:/admin/routes";
    }

    // 4. Schedule Management
    @GetMapping("/schedules")
    public String listSchedules(Model model) {
        List<Schedule> schedules = scheduleService.getAllSchedules();
        model.addAttribute("schedules", schedules);
        return "admin/schedules";
    }

    @GetMapping("/schedules/new")
    public String newScheduleForm(Model model) {
        model.addAttribute("schedule", new Schedule());
        model.addAttribute("buses", busService.getActiveBuses());
        model.addAttribute("routes", routeService.getAllRoutes());
        model.addAttribute("isEdit", false);
        return "admin/schedule-form";
    }

    @PostMapping("/schedules/new")
    public String saveSchedule(@RequestParam("busId") Long busId,
                               @RequestParam("routeId") Long routeId,
                               @RequestParam("journeyDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate journeyDate,
                               @RequestParam("departureTime") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime departureTime,
                               @RequestParam("arrivalTime") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime arrivalTime,
                               @RequestParam("fare") BigDecimal fare,
                               RedirectAttributes redirectAttributes) {
        try {
            Bus bus = busService.getBusById(busId);
            Route route = routeService.getRouteById(routeId);
            Schedule schedule = new Schedule(bus, route, journeyDate, departureTime, arrivalTime, fare);
            scheduleService.createSchedule(schedule);
            redirectAttributes.addFlashAttribute("successMessage", "Schedule created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error saving schedule: " + e.getMessage());
        }
        return "redirect:/admin/schedules";
    }

    @GetMapping("/schedules/edit/{id}")
    public String editScheduleForm(@PathVariable("id") Long id, Model model) {
        Schedule schedule = scheduleService.getScheduleById(id);
        model.addAttribute("schedule", schedule);
        model.addAttribute("buses", busService.getActiveBuses());
        model.addAttribute("routes", routeService.getAllRoutes());
        model.addAttribute("isEdit", true);
        return "admin/schedule-form";
    }

    @PostMapping("/schedules/edit/{id}")
    public String updateSchedule(@PathVariable("id") Long id,
                                 @RequestParam("busId") Long busId,
                                 @RequestParam("routeId") Long routeId,
                                 @RequestParam("journeyDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate journeyDate,
                                 @RequestParam("departureTime") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime departureTime,
                                 @RequestParam("arrivalTime") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime arrivalTime,
                                 @RequestParam("fare") BigDecimal fare,
                                 @RequestParam("status") String status,
                                 RedirectAttributes redirectAttributes) {
        try {
            Bus bus = busService.getBusById(busId);
            Route route = routeService.getRouteById(routeId);
            Schedule schedule = new Schedule(bus, route, journeyDate, departureTime, arrivalTime, fare);
            schedule.setId(id);
            schedule.setStatus(status);
            scheduleService.updateSchedule(schedule);
            redirectAttributes.addFlashAttribute("successMessage", "Schedule updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating schedule: " + e.getMessage());
        }
        return "redirect:/admin/schedules";
    }

    @RequestMapping(value = "/schedules/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String deleteSchedule(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            scheduleService.deleteSchedule(id);
            redirectAttributes.addFlashAttribute("successMessage", "Schedule deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete schedule. Bookings exist for this schedule.");
        }
        return "redirect:/admin/schedules";
    }

    // 5. Booking Management
    @GetMapping("/bookings")
    public String listBookings(Model model) {
        List<Booking> bookings = bookingService.getAllBookings();
        model.addAttribute("bookings", bookings);
        return "admin/bookings";
    }

    @RequestMapping(value = "/bookings/cancel/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String cancelBookingByAdmin(@PathVariable("id") Long bookingId,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        try {
            bookingService.cancelBooking(bookingId, currentUser.getId(), true);
            redirectAttributes.addFlashAttribute("successMessage", "Booking cancelled by admin and seats were released.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error cancelling booking: " + e.getMessage());
        }
        return "redirect:/admin/bookings";
    }

    // 6. User Management
    @GetMapping("/users")
    public String listUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin/users";
    }
}
