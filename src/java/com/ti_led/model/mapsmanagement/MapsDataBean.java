package com.ti_led.model.mapsmanagement;

import com.ti_led.model.mapsmanagement.MapsData;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class MapsDataBean {

    @PersistenceContext
    private EntityManager em;

    public List<MapsData> findAll() {
        TypedQuery<MapsData> query = em.createQuery("SELECT m FROM MapsData m ORDER BY m.noiselogger ASC", MapsData.class);
        return query.getResultList();
    }

    public void save(MapsData mapsData) {
        em.persist(mapsData);
    }

    public void update(MapsData mapsData) {
        em.merge(mapsData);
    }

    public void remove(String noiselogger) {
        MapsData mapsData = find(noiselogger);
        if (mapsData != null) {
            em.remove(mapsData);
        }
    }

    public void remove(MapsData mapsData) {
        if (mapsData != null && em.contains(mapsData)) {
            em.remove(mapsData);
        }
    }

    public MapsData find(String noiselogger) {
        return em.find(MapsData.class, noiselogger);
    }

    public void detach(MapsData mapsData) {
        em.detach(mapsData);
    }
}
