package com.busreservation.controller;

import com.busreservation.config.SecurityInterceptor;
import com.busreservation.entity.User;
import com.busreservation.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "redirect", required = false) String redirect,
                            @RequestParam(value = "error", required = false) String error,
                            HttpSession session,
                            Model model) {
        // If already logged in, redirect away
        User currentUser = (User) session.getAttribute(SecurityInterceptor.SESSION_USER);
        if (currentUser != null) {
            if (currentUser.isAdmin()) {
                return "redirect:/admin/dashboard";
            }
            return redirect != null && !redirect.isEmpty() ? "redirect:" + redirect : "redirect:/";
        }

        if ("invalid_credentials".equals(error)) {
            model.addAttribute("errorMessage", "Invalid email or password. Please try again.");
        } else if ("login_required".equals(error)) {
            model.addAttribute("errorMessage", "Please log in to continue with your booking.");
        } else if ("forbidden".equals(error)) {
            model.addAttribute("errorMessage", "Access denied. Administrative privileges are required.");
        }

        model.addAttribute("redirect", redirect);
        return "auth/login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam("email") String email,
                              @RequestParam("password") String password,
                              @RequestParam(value = "redirect", required = false) String redirect,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userService.authenticate(email, password);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            session.setAttribute(SecurityInterceptor.SESSION_USER, user);
            redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");

            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("/auth/")) {
                return "redirect:" + redirect;
            }
            if (user.isAdmin()) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/";
        }

        redirectAttributes.addAttribute("error", "invalid_credentials");
        if (redirect != null && !redirect.isEmpty()) {
            redirectAttributes.addAttribute("redirect", redirect);
        }
        return "redirect:/auth/login";
    }

    @GetMapping("/register")
    public String registerPage(HttpSession session, Model model) {
        if (session.getAttribute(SecurityInterceptor.SESSION_USER) != null) {
            return "redirect:/";
        }
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String handleRegister(@ModelAttribute("user") User user,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        try {
            User saved = userService.register(user);
            session.setAttribute(SecurityInterceptor.SESSION_USER, saved);
            redirectAttributes.addFlashAttribute("successMessage", "Account created successfully! Welcome to VoyageBus, " + saved.getFullName());
            return "redirect:/";
        } catch (Exception e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("user", user);
            return "auth/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.removeAttribute(SecurityInterceptor.SESSION_USER);
        session.invalidate();
        redirectAttributes.addFlashAttribute("infoMessage", "You have been logged out successfully.");
        return "redirect:/auth/login";
    }
}
