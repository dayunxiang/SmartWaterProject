package com.smart_leak_detection.model.measuremanagement;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class MeasureBean {

    @PersistenceContext
    private EntityManager em;

    public List<Measure> findAll(String company, String noiselogger) {
        TypedQuery<Measure> query = em.createQuery("SELECT m FROM Measure m WHERE m.company=:company AND m.noiselogger=:noiselogger ORDER BY m.id ASC", Measure.class);
        query.setParameter("company", company);
        query.setParameter("noiselogger", noiselogger);
        return query.getResultList();
    }

    public void save(Measure measure) {
        em.persist(measure);
    }

    public void update(Measure measure) {
        em.merge(measure);
    }

    public void remove(String company) {
        Measure measure = find(company);
        if (measure != null) {
            em.remove(measure);
        }
    }

    public void remove(Measure measure) {
        if (measure != null && measure.getCompany() != null && em.contains(measure)) {
            em.remove(measure);
        }
    }

    public Measure find(String noiselogger) {
        TypedQuery<Measure> query = em.createQuery("SELECT m FROM Measure m WHERE m.noiselogger=:noiselogger ORDER BY m.id ASC", Measure.class);
        query.setParameter("noiselogger", noiselogger);
        return query.getResultList().get(0);
    }

    public void detach(Measure measure) {
        em.detach(measure);
    }
}
