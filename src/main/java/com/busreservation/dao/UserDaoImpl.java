package com.busreservation.dao;

import com.busreservation.entity.User;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public User save(User user) {
        sessionFactory.getCurrentSession().save(user);
        return user;
    }

    @Override
    public User update(User user) {
        sessionFactory.getCurrentSession().update(user);
        return user;
    }

    @Override
    public void delete(User user) {
        sessionFactory.getCurrentSession().delete(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        User user = sessionFactory.getCurrentSession().get(User.class, id);
        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        List<User> list = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE LOWER(email) = LOWER(:email)", User.class)
                .setParameter("email", email.trim())
                .getResultList();
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public List<User> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM User ORDER BY createdAt DESC", User.class)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u", Long.class)
                .getSingleResult();
        return count != null ? count : 0L;
    }
}
