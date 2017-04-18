/**
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

/**
 * The Class DBPropertyReader.
 */
public class DBPropertyReader  extends IbatisDAOAdapter 
{
  
  /** The log. */
  protected static Logger log = Logger.getLogger(DBPropertyReader.class); 		
  
	/**
	 * Instantiates a new dB property reader.
	 */
	public DBPropertyReader(){
	}
  
    /**
     * Gets the property string.
     * @param propertyName the property name
     * @return the property string
     */
    @SuppressWarnings("unchecked")
	public String getPropertyString(String propertyName){
		@SuppressWarnings("rawtypes")
		Map param = new HashMap(1);
        param.put("propertyName", propertyName);  
        String propertyValue = (String)getSqlMapClientTemplate().queryForObject("getPropertyString", param);
        log.info("Property " + propertyName + " = " + propertyValue);
        return propertyValue;
    }
    
    /**
     * Gets the property number.
     * @param propertyName the property name
     * @return the property number
     */
    @SuppressWarnings("unchecked")
	public long getPropertyNumber(String propertyName){
    	@SuppressWarnings("rawtypes")
		Map param = new HashMap(1);
        param.put("propertyName", propertyName);  
        long propertyValue = (Long)getSqlMapClientTemplate().queryForObject("getPropertyNumber", param);
        log.info("Property " + propertyName + " = " + propertyValue);
        return propertyValue;
    }

    /**
     * Gets the property date.
     * @param propertyName the property name
     * @return the property date
     */
    @SuppressWarnings("unchecked")
	public Date getPropertyDate(String propertyName){
        @SuppressWarnings("rawtypes")
		Map param = new HashMap(1);
        param.put("propertyName", propertyName);  
        Date propertyValue = (Date)getSqlMapClientTemplate().queryForObject("getPropertyDate", param);
        log.info("Property " + propertyName + " = " + propertyValue);
        return propertyValue;
    }
}
