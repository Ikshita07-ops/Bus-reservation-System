package com.busreservation.controller;

import com.busreservation.config.SecurityInterceptor;
import com.busreservation.dto.BookingRequestDto;
import com.busreservation.entity.Booking;
import com.busreservation.entity.Schedule;
import com.busreservation.entity.User;
import com.busreservation.exception.InvalidBookingException;
import com.busreservation.exception.SeatAlreadyBookedException;
import com.busreservation.exception.UnauthorizedException;
import com.busreservation.service.BookingService;
import com.busreservation.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.*;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ScheduleService scheduleService;

    @GetMapping("/checkout")
    public String checkoutPage(@RequestParam("scheduleId") Long scheduleId,
                               @RequestParam("seats") String seatsParam,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        if (currentUser == null) {
            return "redirect:/auth/login?redirect=/booking/checkout?scheduleId=" + scheduleId + "&seats=" + seatsParam;
        }

        if (seatsParam == null || seatsParam.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please select at least one seat before proceeding to checkout.");
            return "redirect:/search/seat-layout/" + scheduleId;
        }

        List<String> selectedSeats = new ArrayList<>();
        for (String s : seatsParam.split(",")) {
            if (!s.trim().isEmpty()) {
                selectedSeats.add(s.trim());
            }
        }

        Schedule schedule = scheduleService.getScheduleById(scheduleId);
        BigDecimal totalFare = schedule.getFare().multiply(BigDecimal.valueOf(selectedSeats.size()));

        model.addAttribute("schedule", schedule);
        model.addAttribute("selectedSeats", selectedSeats);
        model.addAttribute("totalFare", totalFare);
        model.addAttribute("currentUser", currentUser);

        return "booking/checkout";
    }

    @PostMapping("/confirm")
    public String confirmBooking(@RequestParam("scheduleId") Long scheduleId,
                                 @RequestParam("seatNumbers") List<String> seatNumbers,
                                 @RequestParam("passengerName") String passengerName,
                                 @RequestParam("passengerEmail") String passengerEmail,
                                 @RequestParam("passengerPhone") String passengerPhone,
                                 HttpServletRequest request,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        if (currentUser == null) {
            return "redirect:/auth/login";
        }

        BookingRequestDto dto = new BookingRequestDto();
        dto.setScheduleId(scheduleId);
        dto.setSeatNumbers(seatNumbers);
        dto.setPassengerName(passengerName);
        dto.setPassengerEmail(passengerEmail);
        dto.setPassengerPhone(passengerPhone);

        Map<String, String> genders = new HashMap<>();
        for (String seat : seatNumbers) {
            String g = request.getParameter("gender_" + seat);
            if (g != null) {
                genders.put(seat, g);
            }
        }
        dto.setPassengerGenders(genders);

        try {
            Booking booking = bookingService.createBooking(dto, currentUser.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Booking confirmed successfully! Your booking reference is " + booking.getBookingReference());
            return "redirect:/booking/confirmation/" + booking.getBookingReference();
        } catch (SeatAlreadyBookedException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/search/seat-layout/" + scheduleId;
        } catch (InvalidBookingException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/search/seat-layout/" + scheduleId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred while processing your booking: " + e.getMessage());
            return "redirect:/search/seat-layout/" + scheduleId;
        }
    }

    @GetMapping("/confirmation/{reference}")
    public String confirmationPage(@PathVariable("reference") String reference,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        Booking booking = bookingService.getBookingByReference(reference);

        if (currentUser != null && !currentUser.isAdmin() && !booking.getUser().getId().equals(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "You do not have permission to view this booking.");
            return "redirect:/";
        }

        model.addAttribute("booking", booking);
        return "booking/confirmation";
    }

    @GetMapping("/ticket/{reference}")
    public String ticketPage(@PathVariable("reference") String reference,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        Booking booking = bookingService.getBookingByReference(reference);

        if (currentUser != null && !currentUser.isAdmin() && !booking.getUser().getId().equals(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Access denied.");
            return "redirect:/";
        }

        model.addAttribute("booking", booking);
        return "booking/ticket";
    }

    @GetMapping("/my-bookings")
    public String myBookings(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        List<Booking> bookings = bookingService.getUserBookings(currentUser.getId());
        model.addAttribute("bookings", bookings);
        return "booking/my-bookings";
    }

    @RequestMapping(value = "/cancel/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String cancelBooking(@PathVariable("id") Long bookingId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        try {
            bookingService.cancelBooking(bookingId, currentUser.getId(), currentUser.isAdmin());
            redirectAttributes.addFlashAttribute("successMessage", "Booking cancelled successfully. The reserved seats have been released.");
        } catch (UnauthorizedException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "You are not authorized to cancel this reservation.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Unable to cancel booking: " + e.getMessage());
        }
        return "redirect:/booking/my-bookings";
    }
}
