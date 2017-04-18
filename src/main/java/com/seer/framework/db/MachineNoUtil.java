/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import org.apache.log4j.Logger;



/**
 * The Class MachineNoUtil.
 */
public class MachineNoUtil extends IbatisDAOAdapter {
	
	/** The log. */
	protected static Logger log = Logger.getLogger(MachineNoUtil.class);
	
	/**
	 * Gets the machine no.
	 * 
	 * @return the machine no
	 */
	public String getMachineNo(){
		return (String)getSqlMapClientTemplate().queryForObject("getMachineNo");
		
	}
}
