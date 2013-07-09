package com.smart_leak_detection.model.sensormanagement;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class SensorBean {

    @PersistenceContext
    private EntityManager em;

    public List<Sensor> findAll(String company) {
        TypedQuery<Sensor> query = em.createQuery("SELECT m FROM Measure m WHERE m.company=:company ORDER BY m.id ASC", Sensor.class);
        query.setParameter("company", company);
        return query.getResultList();
    }

    public void save(Sensor sensor) {
        em.persist(sensor);
    }

    public void update(Sensor sensor) {
        em.merge(sensor);
    }

    public void remove(String noiselogger) {
        Sensor sensor = find(noiselogger);
        if (sensor != null) {
            em.remove(sensor);
        }
    }

    public void remove(Sensor sensor) {
        if (sensor != null && sensor.getCompany() != null && em.contains(sensor)) {
            em.remove(sensor);
        }
    }

    public Sensor find(String noiselogger) {
        return em.find(Sensor.class, noiselogger);
    }

    public void detach(Sensor sensor) {
        em.detach(sensor);
    }
}
