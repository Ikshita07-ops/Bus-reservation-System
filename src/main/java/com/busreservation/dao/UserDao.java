package com.busreservation.dao;

import com.busreservation.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserDao {
    User save(User user);
    User update(User user);
    void delete(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    List<User> findAll();
    long countAll();
}
