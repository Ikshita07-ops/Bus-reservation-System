package com.busreservation.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {

    private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder(10);

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return ENCODER.encode(plainPassword);
    }

    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return ENCODER.matches(plainPassword, hashedPassword);
    }

    public static void main(String[] args) {
        System.out.println("admin123: " + hashPassword("admin123"));
        System.out.println("password123: " + hashPassword("password123"));
    }
}
