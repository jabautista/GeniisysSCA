/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;


import org.apache.log4j.Logger;
import org.springframework.jdbc.core.support.JdbcDaoSupport;



/**
 * This class allows developers to implements necessary Spring JDBC
 * DAO support by extending this class.
 * 
 * @author  Rick Sandoval, ricks1219@yahoo.com, ABSi
 * @version 0.1 May 27, 2005
 */
public class DAOAdapter extends JdbcDaoSupport  
{
    
    /** The log. */
    protected static Logger log = Logger.getLogger(DAOAdapter.class);    
    
    /**
     * Instantiates a new dAO adapter.
     */
    protected DAOAdapter()
    {        
        super();
        
    }
    
}
