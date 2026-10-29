package com.busreservation.service;

import com.busreservation.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    User register(User user);
    Optional<User> authenticate(String email, String password);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    List<User> getAllUsers();
    long getTotalUserCount();
}
