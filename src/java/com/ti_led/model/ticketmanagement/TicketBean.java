package com.ti_led.model.ticketmanagement;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class TicketBean {

    @PersistenceContext
    private EntityManager em;

    public List<Ticket> findAll(String company) {
        TypedQuery<Ticket> query = em.createQuery("SELECT t FROM Ticket t WHERE t.company=:company  ORDER BY t.id ASC", Ticket.class);
        query.setParameter("company", company);
        return query.getResultList();
    }

    public void save(Ticket ticket) {
        em.persist(ticket);
    }

    public void update(Ticket ticket) {
        em.merge(ticket);
    }

    public void remove(String company) {
        Ticket ticket = find(company);
        if (ticket != null) {
            em.remove(ticket);
        }
    }

    public void remove(Ticket ticket) {
        if (ticket != null && ticket.getCompany() != null && em.contains(ticket)) {
            em.remove(ticket);
        }
    }

    public Ticket find(String company) {
        return em.find(Ticket.class, company);
    }

    public void detach(Ticket ticket) {
        em.detach(ticket);
    }
}
