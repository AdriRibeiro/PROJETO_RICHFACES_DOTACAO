/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 *
 * @author horacio.vasconcellos
 */
public class JPAUtilitario {

    private static EntityManagerFactory emf = Persistence.createEntityManagerFactory("desenvolvimento");
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
}