/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;


import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;



/**
 * This class allows developers to implements necessary Spring Ibatis Implementation
 * DAO support by extending this class.
 * 
 * @author  Rick Sandoval, ricks1219@yahoo.com, ABSi
 * @version 0.1 May 27, 2005
 */
public class IbatisDAOAdapter extends SqlMapClientDaoSupport 
{
    
    /** The log. */
    protected static Logger log = Logger.getLogger(IbatisDAOAdapter.class);    
    
    /**
     * Instantiates a new ibatis dao adapter.
     */
    protected IbatisDAOAdapter()
    {        
        super();
        
    }
    
    /**
     * Gets the data source connection.
     * 
     * @return the data source connection
     * 
     * @throws Exception if any error occurs during the execution of the method
     */
    public DataSource getDataSourceConnection() throws Exception
    {
        return this.getDataSource();
    }

}
