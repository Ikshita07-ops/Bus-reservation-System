package com.busreservation.service;

import com.busreservation.dao.UserDao;
import com.busreservation.entity.User;
import com.busreservation.exception.InvalidBookingException;
import com.busreservation.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {

    @Mock
    private UserDao userDao;

    @InjectMocks
    private UserServiceImpl userService;

    private User sampleUser;

    @BeforeEach
    public void setup() {
        sampleUser = new User("Test User", "test@example.com", "+91 9999999999", "secret123", User.ROLE_CUSTOMER);
    }

    @Test
    public void testRegisterSuccess() {
        when(userDao.findByEmail("test@example.com")).thenReturn(Optional.empty());
        when(userDao.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        User registered = userService.register(sampleUser);

        assertNotNull(registered);
        assertTrue(PasswordUtil.checkPassword("secret123", registered.getPassword()));
        assertEquals(User.ROLE_CUSTOMER, registered.getRole());
        verify(userDao, times(1)).save(any(User.class));
    }

    @Test
    public void testRegisterDuplicateEmailThrowsException() {
        when(userDao.findByEmail("test@example.com")).thenReturn(Optional.of(sampleUser));

        assertThrows(InvalidBookingException.class, () -> {
            userService.register(sampleUser);
        });

        verify(userDao, never()).save(any(User.class));
    }

    @Test
    public void testAuthenticateSuccess() {
        String hashed = PasswordUtil.hashPassword("secret123");
        sampleUser.setPassword(hashed);
        when(userDao.findByEmail("test@example.com")).thenReturn(Optional.of(sampleUser));

        Optional<User> auth = userService.authenticate("test@example.com", "secret123");
        assertTrue(auth.isPresent());
        assertEquals("Test User", auth.get().getFullName());
    }

    @Test
    public void testAuthenticateFailure() {
        String hashed = PasswordUtil.hashPassword("secret123");
        sampleUser.setPassword(hashed);
        when(userDao.findByEmail("test@example.com")).thenReturn(Optional.of(sampleUser));

        Optional<User> auth = userService.authenticate("test@example.com", "wrongpassword");
        assertFalse(auth.isPresent());
    }
}
