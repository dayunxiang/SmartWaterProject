/**
 * Mon Jun 22 16:17:45 2013
 *
 * @author Simone Amoroso
 * @author Davide Pellegrino
 * @author Pierluigi Scarpetta
 * @author Mauro Vuolo
 *
 * Released under the Apache License, Version 2.0
 */
package com.ti_led.model.usermanagement;

import java.security.Principal;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class UserBean {

    @PersistenceContext
    private EntityManager em;

    public List<User> findAll() {
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u ORDER BY u.registeredOn ASC", User.class);
        return query.getResultList();
    }

    public List<User> findAll(String company) {
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.company=:company", User.class);
        query.setParameter("company", company);
        return query.getResultList();
    }

    public void save(User user) {
        em.persist(user);
    }

    public void update(User user) {
        em.merge(user);
    }

    public void remove(String email) {
        User user = find(email);
        if (user != null) {
            em.remove(user);
        }
    }

    public void remove(User user) {
        if (user != null && user.getEmail() != null && em.contains(user)) {
            em.remove(user);
        }
    }

    public User find(String email) {
        return em.find(User.class, email);
    }

    public void detach(User user) {
        em.detach(user);
    }
}