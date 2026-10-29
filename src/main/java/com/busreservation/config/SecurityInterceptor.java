package com.busreservation.config;

import com.busreservation.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SecurityInterceptor implements HandlerInterceptor {

    public static final String SESSION_USER = "currentUser";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute(SESSION_USER) : null;

        // Admin paths protection
        if (path.startsWith("/admin")) {
            if (currentUser == null) {
                response.sendRedirect(contextPath + "/auth/login?redirect=" + java.net.URLEncoder.encode(path, "UTF-8") + "&error=login_required");
                return false;
            }
            if (!currentUser.isAdmin()) {
                response.sendRedirect(contextPath + "/auth/login?error=forbidden");
                return false;
            }
            return true;
        }

        // Authenticated user paths protection
        if (path.startsWith("/booking/checkout") ||
            path.startsWith("/booking/confirm") ||
            path.startsWith("/booking/my-bookings") ||
            path.startsWith("/booking/cancel") ||
            path.startsWith("/user/")) {

            if (currentUser == null) {
                String fullPath = path;
                if (request.getQueryString() != null) {
                    fullPath += "?" + request.getQueryString();
                }
                response.sendRedirect(contextPath + "/auth/login?redirect=" + java.net.URLEncoder.encode(fullPath, "UTF-8") + "&error=login_required");
                return false;
            }
        }

        return true;
    }
}
