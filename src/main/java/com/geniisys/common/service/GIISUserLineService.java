/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.entity.GIISUserLine;


/**
 * The Interface GIISUserLineService.
 */
public interface GIISUserLineService {
	
	/**
	 * Gets the giis user line list.
	 * 
	 * @param userID the user id
	 * @return the giis user line list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserLine> getGiisUserLineList(String userID) throws SQLException;
	
	/**
	 * Sets the giis user line.
	 * 
	 * @param userLine the new giis user line
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserLine(GIISUserLine userLine) throws SQLException;
	
	/**
	 * Delete giis user line.
	 * 
	 * @param userID the user id
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserLine(String userID) throws SQLException;
}
