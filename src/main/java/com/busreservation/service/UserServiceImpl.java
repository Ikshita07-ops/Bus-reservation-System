package com.busreservation.service;

import com.busreservation.dao.UserDao;
import com.busreservation.entity.User;
import com.busreservation.exception.InvalidBookingException;
import com.busreservation.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User register(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User details must not be null");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new InvalidBookingException("Email address is required");
        }
        if (userDao.findByEmail(user.getEmail().trim()).isPresent()) {
            throw new InvalidBookingException("An account with this email address already exists.");
        }
        if (user.getPassword() == null || user.getPassword().trim().length() < 6) {
            throw new InvalidBookingException("Password must be at least 6 characters long.");
        }

        user.setEmail(user.getEmail().trim().toLowerCase());
        user.setFullName(user.getFullName().trim());
        user.setPhone(user.getPhone().trim());
        user.setPassword(PasswordUtil.hashPassword(user.getPassword().trim()));
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            user.setRole(User.ROLE_CUSTOMER);
        }

        return userDao.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> authenticate(String email, String password) {
        if (email == null || password == null) {
            return Optional.empty();
        }
        Optional<User> userOpt = userDao.findByEmail(email.trim().toLowerCase());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtil.checkPassword(password, user.getPassword())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userDao.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalUserCount() {
        return userDao.countAll();
    }
}
