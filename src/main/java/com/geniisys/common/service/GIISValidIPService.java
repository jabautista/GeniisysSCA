/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;

import com.geniisys.common.entity.GIISValidIP;


/**
 * The Interface GIISValidIPService.
 */
public interface GIISValidIPService {

	/**
	 * Gets the valid user.
	 * 
	 * @param ipAddress the ip address
	 * @return the valid user
	 * @throws SQLException the sQL exception
	 */
	GIISValidIP getValidUser(String ipAddress) throws SQLException;
	
}
