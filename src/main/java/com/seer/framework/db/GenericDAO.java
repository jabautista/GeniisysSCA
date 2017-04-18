/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.util.List;

import com.seer.framework.util.Entity;




/**
 * Data Access Object (Dao) interface.   This is an interface
 * used to tag our Dao classes and to provide common methods to all Daos.
 * 
 * Subclass this one if you want typesafe (no casting necessary) Dao's for you
 * domain objects.
 * 
 * <p><a href="Dao.java.html"><i>View Source</i></a></p>
 * 
 * @param <T> the generic type
 * @author <a href="mailto:bwnoll@gmail.com">Bryan Noll</a>
 */
@SuppressWarnings({ "rawtypes" })
public interface GenericDAO <T extends Entity> {
    
    /**
     * Generic method used to get all objects of a particular type. This
     * is the same as lookup up all rows in a table.
     * 
     * @return List of populated objects
     */
    public List<T> findAll();    
    
    /**
     * Generic method to get an object based on class and identifier. An
     * ObjectRetrievalFailureException Runtime Exception is thrown if
     * nothing is found.
     * 
     * @param id the identifier (primary key) of the object to get
     * 
     * @return a populated object
     * 
     * @see org.springframework.orm.ObjectRetrievalFailureException
     */            
    public T findById(Object id);               

    /**
     * Generic method to save an object - handles both update and insert.
     * 
     * @param object the object
     */
    public void save(T object);

    /**
     * Generic method to delete an object based on class and id.
     * 
     * @param object the object
     */
    public void delete(T object);
}