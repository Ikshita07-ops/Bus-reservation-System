package com.busreservation.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    public void testHashAndVerify() {
        String plain = "admin123";
        String hashed = PasswordUtil.hashPassword(plain);
        assertNotNull(hashed);
        assertTrue(PasswordUtil.checkPassword("admin123", hashed));
        assertFalse(PasswordUtil.checkPassword("wrongpassword", hashed));

        System.out.println("Admin Hash: " + hashed);
        System.out.println("User Hash: " + PasswordUtil.hashPassword("password123"));
    }
}
